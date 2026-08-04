import 'dart:async';
import 'package:geolocator/geolocator.dart';

abstract class LocationListener {
  void onLocationUpdated(Position position);
  void onLocationDisabled();
}

class LocationService {
  final LocationListener listener;
  Timer? _timer;

  LocationService(this.listener);

  /// Start 30-second interval location updates
  Future<void> startLocationUpdates() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check service enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      listener.onLocationDisabled();
      return;
    }

    // Check permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        listener.onLocationDisabled();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      listener.onLocationDisabled();
      return;
    }

    // Start timer for 30-second updates
    _timer = Timer.periodic(const Duration(seconds: 30), (_) async {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        listener.onLocationUpdated(position);
      } catch (e) {
        listener.onLocationDisabled();
      }
    });

    // Also send immediate first location update
    try {
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      listener.onLocationUpdated(pos);
    } catch (e) {
      listener.onLocationDisabled();
    }
  }

  /// Stop the timer when screen closes
  void stopLocationUpdates() {
    _timer?.cancel();
    _timer = null;
  }
}
