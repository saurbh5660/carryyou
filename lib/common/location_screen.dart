import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';

// Ensure these imports match your project structure
import '../views/map/map_screen.dart';
import '../../common/apputills.dart';

class LocationSearchScreen extends StatefulWidget {
  final bool isDestination;
  const LocationSearchScreen({super.key, required this.isDestination});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final String googleApiKey = "AIzaSyAXAv5h2hnQE1QChUPJRCGcEAcYKfOnqgI";
  final Logger logger = Logger();

  static const Color _accent = Color(0xFF1A73E8);

  String _currentAddress = "Fetching location...";
  List<dynamic> _predictions = [];
  bool _isLoading = false;
  Timer? _debounce;
  String _sessionToken = const Uuid().v4();

  final TextEditingController _currentLocationController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final FocusNode _sourceFocus = FocusNode();
  final FocusNode _destFocus = FocusNode();

  double? _pickupLat, _pickupLng, _destLat, _destLng;
  bool _isEditingDestination = true;
  String _query = "";

  @override
  void initState() {
    super.initState();
    _isEditingDestination = widget.isDestination;
    _fetchInitialGPS();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _currentLocationController.dispose();
    _destinationController.dispose();
    _sourceFocus.dispose();
    _destFocus.dispose();
    super.dispose();
  }

  /// Fetches initial GPS to auto-fill the Source Location field
  Future<void> _fetchInitialGPS() async {
    setState(() => _isLoading = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _isLoading = false);
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address =
            "${place.name}, ${place.locality}, ${place.administrativeArea}";

        setState(() {
          _currentAddress = address;
          _pickupLat = position.latitude;
          _pickupLng = position.longitude;
          _currentLocationController.text = address;
        });
      }
    } catch (e) {
      logger.e("Initial GPS Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<Map<String, double>?> _getPlaceDetails(String placeId) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry&key=$googleApiKey";
    try {
      var response = await Dio().get(url);
      if (response.data['status'] == 'OK') {
        final location = response.data['result']['geometry']['location'];
        return {
          "lat": location['lat'],
          "lng": location['lng'],
        };
      }
    } catch (e) {
      logger.e("Place Details Error: $e");
    }
    return null;
  }

  void _checkNavigation() {
    if (_currentLocationController.text.isNotEmpty &&
        _destinationController.text.isNotEmpty &&
        _pickupLat != null &&
        _destLat != null) {
      Logger().d(_currentLocationController.text.toString());
      Get.to(
        () => RideBookingMainScreen(),
        arguments: {
          'pickup_address': _currentLocationController.text,
          'pickup_lat': _pickupLat,
          'pickup_lng': _pickupLng,
          'dest_address': _destinationController.text,
          'dest_lat': _destLat,
          'dest_lng': _destLng,
        },
      );
    }
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() {
        _predictions = [];
        _isLoading = false;
      });
      return;
    }
    setState(() => _isLoading = true);
    final String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$googleApiKey&sessiontoken=$_sessionToken";
    try {
      var response = await Dio().get(url);
      if (response.data['status'] == 'OK') {
        setState(() {
          _predictions = response.data['predictions'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _predictions = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _onChanged(String val) {
    setState(() => _query = val);
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(
        const Duration(milliseconds: 400), () => _searchPlaces(val.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Search Location",
          style: GoogleFonts.poppins(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildHeaderInputs(),
          const SizedBox(height: 6),
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  Widget _buildHeaderInputs() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 11,
                height: 11,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF00897B), width: 3),
                ),
              ),
              Container(
                height: 34,
                width: 1.6,
                color: Colors.grey.shade300,
                margin: const EdgeInsets.symmetric(vertical: 2),
              ),
              const Icon(Icons.location_on, size: 18, color: Colors.red),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              children: [
                _buildField(
                  controller: _currentLocationController,
                  focusNode: _sourceFocus,
                  hint: "Source location",
                  isDest: false,
                ),
                const SizedBox(height: 12),
                _buildField(
                  controller: _destinationController,
                  focusNode: _destFocus,
                  hint: "Where to?",
                  isDest: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Swap source <-> destination
          GestureDetector(
            onTap: _swapLocations,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F8),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.swap_vert_rounded,
                  color: Colors.grey.shade700, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  void _swapLocations() {
    setState(() {
      final tmpText = _currentLocationController.text;
      _currentLocationController.text = _destinationController.text;
      _destinationController.text = tmpText;

      final tmpLat = _pickupLat;
      final tmpLng = _pickupLng;
      _pickupLat = _destLat;
      _pickupLng = _destLng;
      _destLat = tmpLat;
      _destLng = tmpLng;
    });
    _checkNavigation();
  }

  Widget _buildField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required bool isDest,
  }) {
    final bool active = isDest ? _isEditingDestination : !_isEditingDestination;
    return Container(
      decoration: BoxDecoration(
        color: active ? Colors.white : const Color(0xFFF5F6F8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: active ? _accent : Colors.transparent,
          width: 1.4,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: isDest && widget.isDestination,
        onTap: () => setState(() => _isEditingDestination = isDest),
        onChanged: _onChanged,
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
              fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w400),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: InputBorder.none,
          suffixIcon: controller.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      controller.clear();
                      if (active) {
                        _query = "";
                        _predictions = [];
                      }
                    });
                  },
                  child: Icon(Icons.close_rounded,
                      size: 18, color: Colors.grey.shade500),
                )
              : null,
          suffixIconConstraints:
              const BoxConstraints(minWidth: 36, minHeight: 36),
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (_isLoading) return _buildShimmer();

    final bool hasQuery = _query.trim().isNotEmpty;

    return ListView(
      padding: const EdgeInsets.only(top: 6, bottom: 24),
      children: [
        _buildCurrentLocationTile(),
        Divider(height: 1, thickness: 0.6, color: Colors.grey.shade100),
        if (!hasQuery && _predictions.isEmpty)
          _buildEmptyState()
        else if (hasQuery && _predictions.isEmpty)
          _buildNoResults()
        else
          ..._predictions.map((p) => _buildPlaceTile(p)),
      ],
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: 7,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 12, width: double.infinity, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(height: 10, width: 160, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: _accent.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.travel_explore_rounded,
                size: 44, color: _accent),
          ),
          const SizedBox(height: 18),
          Text(
            "Search for a place",
            style: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Text(
            "Start typing an address or landmark\nto see suggestions",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 12.5, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 54, color: Colors.grey.shade400),
          const SizedBox(height: 14),
          Text(
            "No results found",
            style: GoogleFonts.poppins(
                fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Text(
            "Try a different keyword",
            style: GoogleFonts.poppins(fontSize: 12.5, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentLocationTile() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _useCurrentLocation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.my_location_rounded,
                    color: _accent, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Use current location",
                      style: GoogleFonts.poppins(
                          fontSize: 14.5, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _currentAddress,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontSize: 11.5, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _useCurrentLocation() async {
    Utils.showLoading();
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        if (_isEditingDestination) {
          _destinationController.text = _currentAddress;
          _destLat = position.latitude;
          _destLng = position.longitude;
        } else {
          _currentLocationController.text = _currentAddress;
          _pickupLat = position.latitude;
          _pickupLng = position.longitude;
        }
      });

      Utils.hideLoading();
      _checkNavigation();
    } catch (e) {
      Utils.hideLoading();
      Get.snackbar("Error", "Unable to get precise location.");
    }
  }

  Widget _buildPlaceTile(dynamic place) {
    final formatting = place['structured_formatting'];
    String title = formatting?['main_text'] ?? '';
    String subtitle = formatting?['secondary_text'] ?? '';
    String placeId = place['place_id'];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _selectPrediction(placeId, title),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F8),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.location_on_rounded,
                    color: Colors.grey.shade600, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontSize: 14.5, fontWeight: FontWeight.w500),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.north_west_rounded,
                  size: 18, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectPrediction(String placeId, String title) async {
    Utils.showLoading();
    var details = await _getPlaceDetails(placeId);
    Utils.hideLoading();

    if (details != null) {
      setState(() {
        if (_isEditingDestination) {
          _destinationController.text = title;
          _destLat = details['lat'];
          _destLng = details['lng'];
        } else {
          _currentLocationController.text = title;
          _pickupLat = details['lat'];
          _pickupLng = details['lng'];
        }
        _query = "";
        _predictions = [];
        _sessionToken = const Uuid().v4();
      });
      _checkNavigation();
    }
  }
}
