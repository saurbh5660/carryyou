import 'dart:convert';
import 'package:carry_you_user/common/location_service.dart';
import 'package:carry_you_user/model/vehicle_type_response.dart';
import 'package:carry_you_user/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import '../common/apputills.dart';
import '../common/socket_service.dart';
import '../model/booking_detail_response.dart';
import '../network/api_constants.dart';
import '../network/api_provider.dart';
import 'package:geolocator/geolocator.dart';

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

  late LocationService locationService;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxString location = ''.obs;

  RxDouble driverLat = 0.0.obs;
  RxDouble driverLng = 0.0.obs;

  RxSet<Polyline> polylines = <Polyline>{}.obs;
  Rx<BitmapDescriptor> carIcon = BitmapDescriptor.defaultMarker.obs;
  RxString distance = '0 m'.obs;
  RxString duration = '0 mins'.obs;
  late GoogleMapController mapController;

  @override
  onInit() {
    super.onInit();
    bookingId = Get.arguments?["bookingId"] ?? "";
    socketService.connectToServer();
    locationService = LocationService(this);
    socketService.setListener(this);
    startLocation();
  }

  void startLocation() {
    locationService.startLocationUpdates();
  }

  @override
  void onSocketEvent(data, String eventType) {
    if (eventType == 'bookingAcceptReject') {
      try {
        Map<String, dynamic> responseData = data is String
            ? jsonDecode(data)
            : data;
        String incomingBookingId = responseData['id'] ?? "";
        int newStatus = responseData['status'] ?? 0;

        if (incomingBookingId == requestBody.value.id) {
          if (newStatus == 1) {
            print("Driver accepted the ride. Updating UI...");
            requestBody.value = BookingDetailBody.fromJson(responseData);
            updateMapRoute();
            Utils.showSuccessToast(message: "Your ride has been accepted!");
          }
        }
      } catch (e) {
        print("Booking Accept Reject Socket Data Error: $e");
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
          print("Driver accepted the ride. Updating UI...");
          requestBody.value = BookingDetailBody.fromJson(responseData);
          updateMapRoute();
          if(newStatus == 7){
            Get.back();
          }
          if(newStatus == 6){
            showRideCompletedDialog();
          }
        }
      } catch (e) {
        print("Booking Accept Reject Socket Data Error: $e");
      }
    }
  }

  @override
  void onLocationDisabled() {}

  @override
  void onLocationUpdated(Position position) {
    latitude.value = position.latitude;
    longitude.value = position.longitude;
    // updateAddressFromLocation(position.latitude, position.longitude);
  }

  Future<void> updateAddressFromLocation(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;

        /*String fullAddress =
            "${p.name}, ${p.street}, ${p.locality}, ${p.subLocality}, "
            "${p.administrativeArea}, ${p.postalCode}, ${p.country}";*/
        String fullAddress =
            "${p.name}, ${p.locality}, ${p.subLocality}, "
            "${p.administrativeArea}, ${p.postalCode}, ${p.country}";

        location.value = fullAddress;
        print("📌 Address: $fullAddress");
      }
    } catch (e) {
      print("❌ Reverse Geocoding Error: $e");
    }
  }

  Future<void> getBookingDetail() async {
    Logger().d("vdsgsdgsdgsdg-------${(Get.arguments?["bookingId"] ?? "")}");
    final Map<String, dynamic> map = {
      "bookingId": Get.arguments?["bookingId"] ?? "",
    };
    var response = await ApiProvider().bookingDetail(map, true);
    if (response.success == true) {
      requestBody.value = response.body ?? BookingDetailBody();
      driverLat.value =
          double.tryParse(requestBody.value.driver?.latitude ?? "0.0") ?? 0.0;
      driverLng.value =
          double.tryParse(requestBody.value.driver?.longitude ?? "0.0") ?? 0.0;
      if (requestBody.value.status == 0) {
        fetchRoute(pickupLatLngLocation, dropOffLatLngLocation);
      } else if (requestBody.value.status == 1) {
        fetchRoute(
          pickupLatLngLocation,
          LatLng(driverLat.value, driverLng.value),
        );
      } else {
        fetchRoute(
          LatLng(driverLat.value, driverLng.value),
          dropOffLatLngLocation,
        );
      }
    } else {
      Utils.showErrorToast(message: response.message ?? "");
    }
  }

  void updateMapRoute() {
    driverLat.value =
        double.tryParse(requestBody.value.driver?.latitude ?? "0.0") ?? 0.0;
    driverLng.value =
        double.tryParse(requestBody.value.driver?.longitude ?? "0.0") ?? 0.0;
    if (requestBody.value.status == 0) {
      fetchRoute(pickupLatLngLocation, dropOffLatLngLocation);
    } else if (requestBody.value.status == 1) {
      fetchRoute(
        pickupLatLngLocation,
        LatLng(driverLat.value, driverLng.value),
      );
    } else {
      fetchRoute(
        LatLng(driverLat.value, driverLng.value),
        dropOffLatLngLocation,
      );
    }
  }

  Future<void> fetchRoute(LatLng origin, LatLng destination) async {
    print("DEBUG: Fetching route from $origin to $destination");
    PolylinePoints polylinePoints = PolylinePoints();

    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: ApiConstants.placesKey,
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

        // 2. Convert Meters to Miles (1 meter = 0.000621371 miles)
        double miles = totalMeters * 0.000621371;

        // Format: If less than 0.1 miles, show in feet, otherwise show miles
        if (miles < 0.1) {
          distance.value = "${(miles * 5280).toStringAsFixed(0)} ft";
        } else {
          distance.value = "${miles.toStringAsFixed(1)} miles";
        }

        // 3. Format Duration
        if (totalSeconds < 60) {
          duration.value = "1 min";
        } else if (totalSeconds < 3600) {
          duration.value = "${(totalSeconds / 60).ceil()} mins";
        } else {
          int hours = totalSeconds ~/ 3600;
          int mins = (totalSeconds % 3600) ~/ 60;
          duration.value = "$hours hr $mins mins";
        }
        List<LatLng> polylineCoordinates = result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        polylines.value = {
          // Using .value to ensure GetX triggers update
          Polyline(
            polylineId: const PolylineId("route"),
            color: Colors.black,
            points: polylineCoordinates,
            width: 5,
          ),
        };

        updateCameraBounds(origin, destination);
      } else {
        print("DEBUG: No points found. Error: ${result.errorMessage}");
      }
    } catch (e) {
      print("DEBUG: Route error: $e");
    }
  }

  void updateCameraBounds(LatLng origin, LatLng destination) {
    if (origin.latitude == 0.0 || destination.latitude == 0.0) return;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        origin.latitude < destination.latitude
            ? origin.latitude
            : destination.latitude,
        origin.longitude < destination.longitude
            ? origin.longitude
            : destination.longitude,
      ),
      northeast: LatLng(
        origin.latitude > destination.latitude
            ? origin.latitude
            : destination.latitude,
        origin.longitude > destination.longitude
            ? origin.longitude
            : destination.longitude,
      ),
    );

    // Add padding (70) so markers aren't touching the screen edges
    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
  }

  LatLng get pickupLatLngLocation {
    double lat =
        double.tryParse(requestBody.value.pickUpLatitude ?? "0.0") ?? 0.0;
    double lng =
        double.tryParse(requestBody.value.pickUpLongitude ?? "0.0") ?? 0.0;
    return LatLng(lat, lng);
  }

  LatLng get dropOffLatLngLocation {
    double lat =
        double.tryParse(requestBody.value.destinationLatitude ?? "0.0") ?? 0.0;
    double lng =
        double.tryParse(requestBody.value.destinationLongitude ?? "0.0") ?? 0.0;
    return LatLng(lat, lng);
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
      if (status == "3") { // cancelled
        Get.back();
      }

    } else {
      Utils.showErrorToast(message: response.message ?? "");
    }
  }

  @override
  void onClose() {
    super.onClose();
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
                        Get.toNamed(AppRoutes.ratingScreen,arguments: {"detail" : requestBody.value});
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
                        Get.back(); // Closes the dialog
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
