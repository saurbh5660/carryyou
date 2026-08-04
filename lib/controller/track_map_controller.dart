import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:carry_you_user/common/location_service.dart';
import 'package:carry_you_user/model/vehicle_type_response.dart';
import 'package:carry_you_user/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import '../common/apputills.dart';
import '../common/socket_service.dart';
import '../generated/assets.dart';
import '../model/booking_detail_response.dart';
import '../network/api_constants.dart';
import '../network/api_provider.dart';
import 'package:geolocator/geolocator.dart' as geo;

class TrackMapController extends GetxController
    implements SocketListener, LocationListener {
  RxList<VehiclePriceBody> vehicleTypes = RxList();
  int selectedTripIndex = 0;
  DateTime? scheduleDate;
  String? scheduleTime = "";
  String bookingId = "";
  bool? isScheduled = false;
  final SocketService socketService = SocketService();
  RxInt currentStep = 2.obs;
  Rx<BookingDetailBody> requestBody = Rx(BookingDetailBody());
  RxBool isNoDriverFound = false.obs;
  Timer? _timeoutTimer;

  late LocationService locationService;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxString location = ''.obs;

  RxDouble driverLat = 0.0.obs;
  RxDouble driverLng = 0.0.obs;

  RxString distance = '0 m'.obs;
  RxString duration = '0 mins'.obs;

  // Google Map controller + reactive overlays
  GoogleMapController? mapController;
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;
  bool _mapReady = false;

  // Custom marker icons
  BitmapDescriptor? driverIcon;
  BitmapDescriptor? pickupIcon;
  BitmapDescriptor? destinationIcon;

  // Latest route coordinates so we can redraw after the map is ready
  List<LatLng> _routeCoordinates = [];

  // Smooth driver animation state
  Timer? _driverAnimTimer;
  LatLng? _renderedDriverPos;
  double _driverBearing = 0.0;
  int _lastFittedStatus = -999;

  // The car asset points to the right, while Google Maps marker rotation uses
  // north/up as 0 degrees.
  static const double _driverIconRotationOffset = 90.0;

  @override
  onInit() {
    super.onInit();
    bookingId = Get.arguments?["bookingId"] ?? "";
    socketService.connectToServer();
    locationService = LocationService(this);
    socketService.addListener(this);
    startLocation();
  }

  // Called once the Google map is created.
  Future<void> onMapReady(GoogleMapController map) async {
    mapController = map;
    await loadCustomIcons();
    _mapReady = true;

    // Draw whatever data we already have (booking detail may have arrived first)
    updateMapRoute();
  }

  Future<void> loadCustomIcons() async {
    driverIcon = await _bitmapFromAsset(Assets.icons.car.path, 110);
    pickupIcon = await _createDotMarker(const Color(0xFF1FAE5A));
    destinationIcon = await _createDotMarker(const Color(0xFFE53935));
  }

  // Loads an asset image as a BitmapDescriptor scaled to [width].
  Future<BitmapDescriptor> _bitmapFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final bytes = (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(bytes);
  }

  // Builds a clean round location dot (white ring + colored center + soft shadow).
  Future<BitmapDescriptor> _createDotMarker(
    Color color, {
    int size = 96,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final s = size.toDouble();
    final center = Offset(s / 2, s / 2);

    canvas.drawCircle(
      center,
      s * 0.30,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawCircle(center, s * 0.28, Paint()..color = Colors.white);
    canvas.drawCircle(center, s * 0.20, Paint()..color = color);
    canvas.drawCircle(center, s * 0.08, Paint()..color = Colors.white);

    final image = await recorder.endRecording().toImage(size, size);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  void startLocation() {
    locationService.startLocationUpdates();
  }

  void _startTimeoutTimer() {
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (requestBody.value.status == 0) {
        _checkTimeout();
      } else {
        timer.cancel();
      }
    });
  }

  void _checkTimeout() {
    if (requestBody.value.createdAt != null) {
      try {
        DateTime createdAt = DateTime.parse(
          requestBody.value.createdAt!,
        ).toLocal();
        DateTime now = DateTime.now();
        if (now.difference(createdAt).inMinutes >= 5) {
          isNoDriverFound.value = true;
          _timeoutTimer?.cancel();
        }
      } catch (e) {
        Logger().e("Error parsing createdAt: $e");
      }
    }

    if ((requestBody.value.bookingRejectCount ?? 0) >= 10) {
      isNoDriverFound.value = true;
      _timeoutTimer?.cancel();
    }
  }

  @override
  void onSocketEvent(data, String eventType) {
    if (eventType == 'bookingAcceptRejectCount') {
      try {
        Map<String, dynamic> responseData = data is String
            ? jsonDecode(data)
            : data;
        String incomingBookingId = responseData['id']?.toString() ?? "";
        if (incomingBookingId == requestBody.value.id) {
          requestBody.update((val) {
            val?.bookingRejectCount = responseData['bookingRejectCount'];
          });
          _checkTimeout();
        }
      } catch (e) {
        Logger().e("Booking Accept Reject Count Socket Error: $e");
      }
    }
    if (eventType == 'bookingAcceptReject') {
      try {
        Map<String, dynamic> responseData = data is String
            ? jsonDecode(data)
            : data;
        String incomingBookingId = responseData['id'] ?? "";
        int newStatus = responseData['status'] ?? 0;

        if (incomingBookingId == requestBody.value.id) {
          if (newStatus == 1) {
            Logger().d("Driver accepted the ride. Updating UI...");
            requestBody.value = BookingDetailBody.fromJson(responseData);
            updateMapRoute();
          }
        }
      } catch (e) {
        Logger().e("Booking Accept Reject Socket Data Error: $e");
      }
    }
    if (eventType == 'bookingStatusChange') {
      try {
        Map<String, dynamic> responseData = data is String
            ? jsonDecode(data)
            : data;
        String incomingBookingId = responseData['id'] ?? "";
        int newStatus = responseData['status'] ?? 0;

        if (incomingBookingId == requestBody.value.id) {
          requestBody.value = BookingDetailBody.fromJson(responseData);
          updateMapRoute();
          if (newStatus == 7) {
            Get.back();
          }
          if (newStatus == 6) {
            showRideCompletedDialog();
          }
        }
      } catch (e) {
        Logger().e("Booking Accept Reject Socket Data Error: $e");
      }
    }
    if (eventType == 'driver_location_update') {
      try {
        Logger().d("fgnnnnnnnnn------");
        Map<String, dynamic> responseData = data is String
            ? jsonDecode(data)
            : data;
        final double newLat =
            double.tryParse(responseData['latitude']?.toString() ?? "0.0") ??
            0.0;
        final double newLng =
            double.tryParse(responseData['longitude']?.toString() ?? "0.0") ??
            0.0;
        if (newLat == 0.0 && newLng == 0.0) return;
        driverLat.value = newLat;
        driverLng.value = newLng;
        // Smoothly animate the car to the new position and refresh the route.
        Logger().d("bbbbbbbbbbb------");

        _onDriverMoved(LatLng(newLat, newLng));
      } catch (e) {
        Logger().d("ccccccccccccc------");

        Logger().e("Driver Location Update Error: $e");
      }
    }
  }

  @override
  void onLocationDisabled() {}

  @override
  void onLocationUpdated(geo.Position position) {
    latitude.value = position.latitude;
    longitude.value = position.longitude;

    socketService.sendLocationToDriver({
      "bookingId": requestBody.value.id,
      "lat": position.latitude,
      "lng": position.longitude,
      "location": location.value,
    });

    updateAddressFromLocation(position.latitude, position.longitude);
  }

  Future<void> updateAddressFromLocation(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        String fullAddress =
            "${p.name}, ${p.locality}, ${p.subLocality}, "
            "${p.administrativeArea}, ${p.postalCode}, ${p.country}";

        location.value = fullAddress;
        Logger().d("Address: $fullAddress");
      }
    } catch (e) {
      Logger().e("Reverse Geocoding Error: $e");
    }
  }

  Future<void> getBookingDetail() async {
    final Map<String, dynamic> map = {
      "bookingId": Get.arguments?["bookingId"] ?? "",
    };
    var response = await ApiProvider().bookingDetail(map, true);
    if (response.success == true) {
      requestBody.value = response.body ?? BookingDetailBody();
      updateMapRoute();
      if (requestBody.value.status == 6) {
        showRideCompletedDialog();
      }
      if (requestBody.value.status == 0) {
        _checkTimeout();
        _startTimeoutTimer();
      }
    } else {
      Utils.showErrorToast(message: response.message ?? "");
    }
  }

  int get _status => (requestBody.value.status ?? 0).toInt();

  // True once the driver has picked up the parcel/passenger (status 10).
  bool get _isPickedUp => _status == 10 || _status == 5 || _status == 6;

  // Refreshes driver position, markers and the route based on current status.
  void updateMapRoute() {
    // Seed the driver position from the booking detail if we don't have a
    // socket location yet.
    final double dLat =
        double.tryParse(requestBody.value.driver?.latitude ?? "0.0") ?? 0.0;
    final double dLng =
        double.tryParse(requestBody.value.driver?.longitude ?? "0.0") ?? 0.0;
    if (dLat != 0.0 || dLng != 0.0) {
      driverLat.value = dLat;
      driverLng.value = dLng;
      _renderedDriverPos ??= LatLng(dLat, dLng);
    }

    _updateDriverBearingTowardRouteTarget();
    _drawMarkers();

    final bool fit = _lastFittedStatus != _status || _routeCoordinates.isEmpty;
    _lastFittedStatus = _status;

    if (_status == 0) {
      // Searching for a driver – show the overview pickup -> destination.
      fetchRoute(pickupLatLng, destinationLatLng, fitCamera: fit);
    } else if (_isPickedUp) {
      // Picked up – route from the (live) driver location to destination.
      fetchRoute(driverLatLng, destinationLatLng, fitCamera: fit);
    } else {
      // Accepted / on the way – route from the driver to pickup.
      fetchRoute(driverLatLng, pickupLatLng, fitCamera: fit);
    }
  }

  // Draws pickup / driver / destination markers depending on booking status.
  void _drawMarkers() {
    if (!_mapReady) return;

    final Set<Marker> next = {};

    if (_status == 0) {
      next.add(_marker("pickup", pickupLatLng, pickupIcon));
      next.add(_marker("destination", destinationLatLng, destinationIcon));
    } else if (_isPickedUp) {
      next.add(_marker("destination", destinationLatLng, destinationIcon));
      next.add(_driverMarker(_renderedDriverPos ?? driverLatLng));
    } else {
      next.add(_marker("pickup", pickupLatLng, pickupIcon));
      next.add(_driverMarker(_renderedDriverPos ?? driverLatLng));
    }

    markers
      ..clear()
      ..addAll(next);
  }

  Marker _marker(String id, LatLng pos, BitmapDescriptor? icon) {
    return Marker(
      markerId: MarkerId(id),
      position: pos,
      icon: icon ?? BitmapDescriptor.defaultMarker,
      anchor: const Offset(0.5, 0.5),
      zIndexInt: 1,
    );
  }

  Marker _driverMarker(LatLng pos) {
    return Marker(
      markerId: const MarkerId("driver"),
      position: pos,
      icon: driverIcon ?? BitmapDescriptor.defaultMarker,
      rotation: _driverMarkerRotation,
      anchor: const Offset(0.5, 0.5),
      flat: true,
      zIndexInt: 3,
    );
  }

  double get _driverMarkerRotation =>
      (_driverBearing - _driverIconRotationOffset + 360) % 360;

  void _updateDriverBearingTowardRouteTarget() {
    if (_status == 0) return;

    final LatLng current = _renderedDriverPos ?? driverLatLng;
    final LatLng target = _isPickedUp ? destinationLatLng : pickupLatLng;
    if (!_isValidLatLng(current) ||
        !_isValidLatLng(target) ||
        _isSameLatLng(current, target)) {
      return;
    }

    _driverBearing = _bearingBetween(current, target);
  }

  // Animates the car marker smoothly from its current rendered position to the
  // newly received socket position, rotating it to face the direction of travel.
  void _onDriverMoved(LatLng newPos) {
    if (!_mapReady) {
      _renderedDriverPos = newPos;
      return;
    }

    final LatLng start = _renderedDriverPos ?? newPos;
    final double targetBearing = _isSameLatLng(start, newPos)
        ? _driverBearing
        : _bearingBetween(start, newPos);
    final double startBearing = _driverBearing;

    _driverAnimTimer?.cancel();
    const int steps = 30; // ~1s at 60fps-ish cadence
    const Duration frame = Duration(milliseconds: 30);
    int i = 0;

    _driverAnimTimer = Timer.periodic(frame, (timer) {
      i++;
      final double t = (i / steps).clamp(0.0, 1.0);
      final double lat =
          start.latitude + (newPos.latitude - start.latitude) * t;
      final double lng =
          start.longitude + (newPos.longitude - start.longitude) * t;
      _renderedDriverPos = LatLng(lat, lng);
      _driverBearing = _lerpAngle(startBearing, targetBearing, t);

      _updateDriverMarkerOnly(_renderedDriverPos!);

      if (t >= 1.0) {
        timer.cancel();
        _renderedDriverPos = newPos;
        // Once the car has reached the latest point, refresh the route line so
        // it stays glued to the live driver position.
        // Pickup phase: driver -> pickup. Picked-up phase: driver -> destination.
        if (_status != 0) {
          if (_isPickedUp) {
            fetchRoute(newPos, destinationLatLng, fitCamera: false);
          } else {
            fetchRoute(newPos, pickupLatLng, fitCamera: false);
          }
        }
      }
    });
  }

  void _updateDriverMarkerOnly(LatLng pos) {
    markers.removeWhere((m) => m.markerId.value == "driver");
    markers.add(_driverMarker(pos));
    markers.refresh();
  }

  Future<void> fetchRoute(
    LatLng origin,
    LatLng destination, {
    bool fitCamera = true,
  }) async {
    if (!_mapReady) return;
    if ((origin.latitude == 0.0 && origin.longitude == 0.0) ||
        (destination.latitude == 0.0 && destination.longitude == 0.0)) {
      return;
    }

    Logger().d(
      "origgnlaaaaa--- ${origin.latitude} origgnlngggg---   ${origin.longitude} desttttlatttttt--- ${destination.latitude} destinlnggggg----- ${destination.longitude}",
    );
    PolylinePoints polylinePoints = PolylinePoints.legacy(
      ApiConstants.placesKey,
    );

    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(origin.latitude, origin.longitude),
          destination: PointLatLng(destination.latitude, destination.longitude),
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isNotEmpty) {
        int totalMeters = 0;
        int totalSeconds = 0;

        if (result.distanceValues != null) {
          for (int m in result.distanceValues!) {
            totalMeters += m;
          }
        }
        if (result.durationValues != null) {
          for (int s in result.durationValues!) {
            totalSeconds += s;
          }
        }

        double miles = totalMeters * 0.000621371;
        if (miles < 0.1) {
          distance.value = "${(miles * 5280).toStringAsFixed(0)} ft";
        } else {
          distance.value = "${miles.toStringAsFixed(1)} miles";
        }

        if (totalSeconds < 60) {
          duration.value = "1 min";
        } else if (totalSeconds < 3600) {
          duration.value = "${(totalSeconds / 60).ceil()} mins";
        } else {
          int hours = totalSeconds ~/ 3600;
          int mins = (totalSeconds % 3600) ~/ 60;
          duration.value = "$hours hr $mins mins";
        }

        _routeCoordinates = result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        _drawRoute();
        if (fitCamera) {
          await _fitCameraToRoute(_routeCoordinates);
        }
      } else {
        Logger().d("No points found. Error: ${result.errorMessage}");
      }
    } catch (e) {
      Logger().e("Route error: $e");
    }
  }

  void _drawRoute() {
    if (!_mapReady) return;
    polylines.clear();
    if (_routeCoordinates.isEmpty) return;
    polylines.add(
      Polyline(
        polylineId: const PolylineId("route"),
        points: _routeCoordinates,
        color: const Color(0xFF1A73E8),
        width: 6,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
        geodesic: true,
      ),
    );
  }

  Future<void> _fitCameraToRoute(List<LatLng> points) async {
    if (mapController == null || points.isEmpty) return;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    try {
      await mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 70),
      );
    } catch (e) {
      Logger().e("Camera fit error: $e");
    }
  }

  LatLng get pickupLatLng {
    double lat =
        double.tryParse(requestBody.value.pickUpLatitude ?? "0.0") ?? 0.0;
    double lng =
        double.tryParse(requestBody.value.pickUpLongitude ?? "0.0") ?? 0.0;
    return LatLng(lat, lng);
  }

  LatLng get destinationLatLng {
    double lat =
        double.tryParse(requestBody.value.destinationLatitude ?? "0.0") ?? 0.0;
    double lng =
        double.tryParse(requestBody.value.destinationLongitude ?? "0.0") ?? 0.0;
    return LatLng(lat, lng);
  }

  LatLng get driverLatLng => LatLng(driverLat.value, driverLng.value);

  bool _isValidLatLng(LatLng pos) =>
      pos.latitude != 0.0 || pos.longitude != 0.0;

  bool _isSameLatLng(LatLng a, LatLng b) =>
      (a.latitude - b.latitude).abs() < 0.000001 &&
      (a.longitude - b.longitude).abs() < 0.000001;

  // Bearing (degrees, 0-360) from point [a] to point [b].
  double _bearingBetween(LatLng a, LatLng b) {
    final double lat1 = a.latitude * math.pi / 180;
    final double lat2 = b.latitude * math.pi / 180;
    final double dLng = (b.longitude - a.longitude) * math.pi / 180;
    final double y = math.sin(dLng) * math.cos(lat2);
    final double x =
        math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLng);
    final double brng = math.atan2(y, x) * 180 / math.pi;
    return (brng + 360) % 360;
  }

  double _lerpAngle(double a, double b, double t) {
    final double diff = ((b - a + 540) % 360) - 180;
    return (a + diff * t) % 360;
  }

  Future<void> updateStatus(String status, String selectedReason) async {
    final Map<String, dynamic> map = {
      "bookingId": bookingId,
      "status": status,
      "reason": selectedReason,
    };
    var response = await ApiProvider().bookingAcceptReject(map, true);
    if (response.success == true) {
      requestBody.value = response.body ?? BookingDetailBody();
      if (status == "3") {
        Get.back();
      }
    } else {
      Utils.showErrorToast(message: response.message ?? "");
    }
  }

  @override
  void onClose() {
    _timeoutTimer?.cancel();
    _driverAnimTimer?.cancel();
    mapController?.dispose();
    super.onClose();
    socketService.removeListener(this);
    locationService.stopLocationUpdates();
  }

  void showRideCompletedDialog() {
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Success Green Checkmark
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              const SizedBox(height: 25),

              // 2. Title
              Text(
                "Ride Completed",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),

              // 3. Description text
              Text(
                "Your Ride Complete successfully.\nPlease give rating & reviews to driver.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),

              // 4. Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.toNamed(
                          AppRoutes.ratingScreen,
                          arguments: {"detail": requestBody.value},
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Rating Now",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.offAllNamed(AppRoutes.homeScreen);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Later",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
