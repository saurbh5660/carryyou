import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import '../views/map/map_screen.dart';
import '../../common/apputills.dart'; // Assuming you have Utils.showLoading()

class LocationSearchScreen extends StatefulWidget {
  final bool isDestination;
  const LocationSearchScreen({super.key, required this.isDestination});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final String googleApiKey = "AIzaSyAXAv5h2hnQE1QChUPJRCGcEAcYKfOnqgI";

  String _currentAddress = "Fetch Current Location";
  List<dynamic> _predictions = [];
  bool _isLoading = false;
  Timer? _debounce;
  String _sessionToken = const Uuid().v4();

  final TextEditingController _currentLocationController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  // State variables for coordinates
  double? _pickupLat, _pickupLng, _destLat, _destLng;
  bool _isEditingDestination = true;

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
    super.dispose();
  }

  Future<void> _fetchInitialGPS() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);

      // Store current GPS as pickup by default
      _pickupLat = position.latitude;
      _pickupLng = position.longitude;

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        setState(() {
          _currentAddress = "${placemarks[0].name}, ${placemarks[0].locality}";
        });
      }
    } catch (e) {
      debugPrint("GPS Error: $e");
    }
  }

  // --- 1. New Helper to fetch Lat/Lng from Place ID ---
  Future<Map<String, double>?> _getPlaceDetails(String placeId) async {
    final String url = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry&key=$googleApiKey";
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
      debugPrint("Place Details Error: $e");
    }
    return null;
  }

  // --- 2. Navigation using Arguments ---
  void _checkNavigation() {
    if (_currentLocationController.text.isNotEmpty &&
        _destinationController.text.isNotEmpty &&
        _pickupLat != null && _destLat != null) {

      Logger().d("dsdsgdsgdsgdsg---- "+_pickupLat.toString());
      Logger().d("dsdsgdsgdsgdsg---- "+_pickupLng.toString());
      Get.to(() => RideBookingMainScreen(),
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
      setState(() { _predictions = []; _isLoading = false; });
      return;
    }
    setState(() => _isLoading = true);
    final String url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$googleApiKey&sessiontoken=$_sessionToken";
    try {
      var response = await Dio().get(url);
      if (response.data['status'] == 'OK') {
        setState(() {
          _predictions = response.data['predictions'];
          _isLoading = false;
        });
      } else {
        setState(() { _predictions = []; _isLoading = false; });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Get.back()),
        title: Text("Search Location", style: GoogleFonts.poppins(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildHeaderInputs(),
          const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.black))
                : ListView.builder(
              itemCount: _predictions.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) return _buildCurrentLocationTile();
                return _buildPlaceTile(_predictions[index - 1]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderInputs() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Column(children: [
            const Icon(Icons.radio_button_checked, size: 18, color: Colors.green),
            Container(height: 35, width: 1, color: Colors.grey.shade300),
            const Icon(Icons.location_on, size: 18, color: Colors.red),
          ]),
          const SizedBox(width: 15),
          Expanded(
            child: Column(children: [
              _buildField(_currentLocationController, "Source Location", false),
              const SizedBox(height: 12),
              _buildField(_destinationController, "Destination Location", true),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint, bool isDest) {
    return Container(
      height: 45,
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
      child: TextField(
        controller: controller,
        autofocus: isDest && widget.isDestination,
        onTap: () => setState(() => _isEditingDestination = isDest),
        onChanged: (val) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(const Duration(milliseconds: 500), () => _searchPlaces(val));
        },
        decoration: InputDecoration(hintText: hint, contentPadding: const EdgeInsets.symmetric(horizontal: 15), border: InputBorder.none),
      ),
    );
  }

  Widget _buildCurrentLocationTile() {
    return ListTile(
      leading: const Icon(Icons.my_location, color: Colors.blue),
      title: Text("Use Current Location", style: GoogleFonts.poppins(fontSize: 14)),
      subtitle: Text(_currentAddress, style: const TextStyle(fontSize: 11)),
      onTap: () async {
        // Fetch fresh coordinates if not already available
        Position position = await Geolocator.getCurrentPosition();
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
        _checkNavigation();
      },
    );
  }

  Widget _buildPlaceTile(dynamic place) {
    final formatting = place['structured_formatting'];
    String title = formatting?['main_text'] ?? '';
    String subtitle = formatting?['secondary_text'] ?? '';
    String placeId = place['place_id'];

    return ListTile(
      leading: const Icon(Icons.location_on_outlined, color: Colors.grey),
      title: Text(title, style: GoogleFonts.poppins(fontSize: 14)),
      subtitle: Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
      onTap: () async {
        // Fetch Lat/Lng before navigating
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
          });
          _checkNavigation();
        }
      },
    );
  }
}