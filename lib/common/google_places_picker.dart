import 'package:flutter/material.dart';
import 'package:place_picker_google/place_picker_google.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class GooglePlacePickerScreen extends StatelessWidget {
  const GooglePlacePickerScreen({super.key});

  Future<LatLng> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print("Error getting location: $e");
      // Return default location if current location fails
      return const LatLng(20.5937, 78.9629);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LatLng>(
      future: _getCurrentLocation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final initialLocation = snapshot.data ?? const LatLng(20.5937, 78.9629);

        return PlacePicker(
          apiKey: "AIzaSyAXAv5h2hnQE1QChUPJRCGcEAcYKfOnqgI",
          usePinPointingSearch: true,
          showSearchInput: true,
          enableNearbyPlaces: false,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          // automaticallyAnimateToCurrentLocation: true,
          initialLocation: initialLocation,
          onPlacePicked: (LocationResult result) {
            String street = "";
            String city = "";
            String state = "";
            String zip = "";
            String country = "";

            if (result.streetNumber?.longName != null) {
              street = result.streetNumber!.longName!;
            }
            if (result.route?.longName != null) {
              street = "$street ${result.route!.longName!}".trim();
            }

            if (result.locality?.longName != null) {
              city = result.locality!.longName!;
            }

            if (result.administrativeAreaLevel1?.longName != null) {
              state = result.administrativeAreaLevel1!.longName!;
            }

            if (result.postalCode?.longName != null) {
              zip = result.postalCode!.longName!;
            }

            if (result.country?.longName != null) {
              country = result.country!.longName!;
            }

            String finalAddress = [
              street,
              city,
              state,
              zip,
              country
            ].where((e) => e.isNotEmpty).join(", ");

            Navigator.pop(context, {
              "address": finalAddress,
              "lat": result.latLng?.latitude.toString(),
              "lng": result.latLng?.longitude.toString(),
            });
          },
        );
      },
    );
  }
}