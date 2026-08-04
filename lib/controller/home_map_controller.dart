import 'package:carry_you_user/common/location_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

class HomeMapController extends GetxController
    implements LocationListener {
  late LocationService locationService;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxString location = ''.obs;

  late GoogleMapController mapController;

  @override
  onInit() {
    super.onInit();
    locationService = LocationService(this);
    startLocation();
  }

  void startLocation() {
    locationService.startLocationUpdates();
  }

  @override
  void onLocationDisabled() {}

  @override
  void onLocationUpdated(Position position) {
    latitude.value = position.latitude;
    longitude.value = position.longitude;
    Logger().d(latitude.value);
    Logger().d(longitude.value);
    // updateAddressFromLocation(position.latitude, position.longitude);
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(latitude.value, longitude.value),16
      ),
    );
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
        print("📌 Address: $fullAddress");
      }
    } catch (e) {
      print("❌ Reverse Geocoding Error: $e");
    }
  }

  @override
  void onClose() {
    super.onClose();
    locationService.stopLocationUpdates();
  }

}
