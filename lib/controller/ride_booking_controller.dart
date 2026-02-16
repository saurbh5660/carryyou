import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../network/api_constants.dart';
import '../network/api_provider.dart';
import '../common/apputills.dart';
import '../model/vehicle_type_response.dart';
import '../routes/app_routes.dart';

class RideBookingController extends GetxController {
  // UI States
  RxInt currentStep = 0.obs;
  RxList<VehiclePriceBody> vehicleTypes = <VehiclePriceBody>[].obs;
  RxInt selectedTripIndex = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isPetsAllowed = false.obs;

  // Map Variables
  GoogleMapController? mapController;
  RxDouble pickupLat = 0.0.obs;
  RxDouble pickupLng = 0.0.obs;
  RxString pickupLocation = "Locating...".obs;
  LatLng? tempCenterLocation;

  RxSet<Polyline> polylines = <Polyline>{}.obs;
  RxSet<Marker> markers = <Marker>{}.obs;
  RxString distance = "".obs;

  // Scheduling
  DateTime? scheduleDate;
  bool isScheduled = false;

  @override
  void onInit() {
    super.onInit();
    // Initialize with arguments passed from previous screen
    Logger().d("fffffffff---- "+(Get.arguments?["pickup_lat"] ?? 0.0).toString());
    Logger().d("nnnnnnnnn----- "+(Get.arguments?["pickup_lng"] ?? 0.0).toString());
    Logger().d("nnnnnnnnnrrr----- "+(Get.arguments?["pickup_address"] ?? 0.0).toString());
    pickupLat.value = Get.arguments?["pickup_lat"] ?? 0.0;
    pickupLng.value = Get.arguments?["pickup_lng"] ?? 0.0;
    pickupLocation.value = Get.arguments?["pickup_address"] ?? "";
    getTypesOfVehicle();
  }

  // Updates address when the user drags the map in Step 0
  void onMapIdle() async {
    if (tempCenterLocation != null && currentStep.value == 0) {
      pickupLat.value = tempCenterLocation!.latitude;
      pickupLng.value = tempCenterLocation!.longitude;
      await updateAddressFromLocation(pickupLat.value, pickupLng.value);
      getTypesOfVehicle();
    }
  }

  Future<void> updateAddressFromLocation(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        pickupLocation.value = "${p.name}, ${p.locality}";
      }
    } catch (e) {
      debugPrint("Geocoding error: $e");
    }
  }

  // Draws the route between pickup and destination
  Future<void> fetchRoute() async {
    isLoading.value = true;
    polylines.clear();
    markers.clear();

    LatLng origin = LatLng(pickupLat.value, pickupLng.value);
    LatLng destination = LatLng(
      double.tryParse(Get.arguments?["dest_lat"].toString() ?? "0") ?? 0.0,
      double.tryParse(Get.arguments?["dest_lng"].toString() ?? "0") ?? 0.0,
    );

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: ApiConstants.placesKey,
      request: PolylineRequest(
        origin: PointLatLng(origin.latitude, origin.longitude),
        destination: PointLatLng(destination.latitude, destination.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      markers.value = {
        Marker(markerId: const MarkerId("src"), position: origin, icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)),
        Marker(markerId: const MarkerId("dst"), position: destination),
      };

      List<LatLng> coords = result.points.map((p) => LatLng(p.latitude, p.longitude)).toList();
      polylines.add(Polyline(
        polylineId: const PolylineId("route"),
        points: coords,
        color: Colors.black,
        width: 2,
      ));

      if (result.distanceValues != null && result.distanceValues!.isNotEmpty) {
        double miles = result.distanceValues!.reduce((a, b) => a + b) * 0.000621371;
        distance.value = "${miles.toStringAsFixed(1)} miles";
      }

      // Delay to ensure padding is applied before the camera moves
      Future.delayed(const Duration(milliseconds: 150), () => updateCameraBounds(origin, destination));
    }
    isLoading.value = false;
  }

  void updateCameraBounds(LatLng origin, LatLng destination) {
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(origin.latitude < destination.latitude ? origin.latitude : destination.latitude, origin.longitude < destination.longitude ? origin.longitude : destination.longitude),
      northeast: LatLng(origin.latitude > destination.latitude ? origin.latitude : destination.latitude, origin.longitude > destination.longitude ? origin.longitude : destination.longitude),
    );
    mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
  }

  Future<void> getTypesOfVehicle() async {
    final Map<String, dynamic> map = {
      "pickUpLatitude": pickupLat.value.toString(),
      "pickUpLongitude": pickupLng.value.toString(),
      "dropLatitude": Get.arguments?["dest_lat"].toString(),
      "dropLongitude": Get.arguments?["dest_lng"].toString(),
    };
    var response = await ApiProvider().getVehiclePrice(map);
    if (response.success == true) {
      vehicleTypes.assignAll(response.body ?? []);
    }
  }

  Future<void> createBooking() async {
    if (vehicleTypes.isEmpty) return;
    Utils.showLoading();

    final Map<String, dynamic> map = {
      "pickUpLatitude": pickupLat.value.toString(),
      "pickUpLongitude": pickupLng.value.toString(),
      "pickUpLocation": pickupLocation.value,
      "destinationLatitude": Get.arguments?["dest_lat"].toString(),
      "destinationLongitude": Get.arguments?["dest_lng"].toString(),
      "destinationLocation": Get.arguments?["dest_address"].toString(),
      "typeOfVehicleId": vehicleTypes[selectedTripIndex.value].id.toString(),
      "amount": vehicleTypes[selectedTripIndex.value].estimatedFare ?? 0.0,
      "distance": vehicleTypes[selectedTripIndex.value].distanceKm.toString(),
      "scheduleType": isScheduled ? 2 : 1,
      "pets": isPetsAllowed.value ? 1 : 0,
    };

    if (isScheduled && scheduleDate != null) {
      map["bookingDate"] = DateFormat('yyyy-MM-dd').format(scheduleDate!);
      map["bookingTime"] = DateFormat('HH:mm:ss').format(scheduleDate!);
    }

    var response = await ApiProvider().createBooking(map);
    Utils.hideLoading();

    if (response.success == true) {
      Stripe.publishableKey = "pk_test_51ROCVqPR0LipSHIytuyQNFhaZMGngeu4jmIH2Zg6EI5Mq43AwRv4lShP39VaFk4mpBTnAeWhDIjmq3flfl1FAGK900bI92msNX";
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: response.body?.paymentIntent?.clientSecret ?? "",
          customerEphemeralKeySecret: response.body?.ephemeralKey ?? "",
          customerId: response.body?.customer ?? "",
          merchantDisplayName: "CarryU",
        ),
      );

      try {
        await Stripe.instance.presentPaymentSheet();
        bool isConfirmed = await bookingConfirmation(response.body?.transactionId ?? "");
        if (isConfirmed) {
          Get.offNamed(AppRoutes.trackMapScreen, arguments: {"bookingId": response.body?.bookingId.toString()});
        }
      } catch (e) {
        Utils.showErrorToast(message: "Payment Cancelled");
      }
    }
  }

  Future<bool> bookingConfirmation(String transactionId) async {
    var response = await ApiProvider().bookingConfirmation({"transactionId": transactionId});
    return response.success ?? false;
  }
}