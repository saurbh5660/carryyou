import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../common/location_service.dart';
import '../common/socket_service.dart';
import '../generated/assets.dart';
import '../model/lost_item_request_detail_response.dart';
import '../network/api_constants.dart';
import '../network/api_provider.dart';

class LostItemMapController extends GetxController implements SocketListener {
  final SocketService socketService = SocketService();
  Rx<LostItemRequestDetail> requestBody = Rx(LostItemRequestDetail());
  late GoogleMapController mapController;

  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxSet<Polyline> polylines = <Polyline>{}.obs;

  RxString distance = '0 miles'.obs;
  RxString duration = '0 mins'.obs;
  BitmapDescriptor? driverIcon;
  RxDouble heading = 0.0.obs;

  LatLng get dropOffLatLng {
    double lat = double.tryParse(requestBody.value.driver?.latitude ?? "0.0") ?? 0.0;
    double lng = double.tryParse(requestBody.value.driver?.longitude ?? "0.0") ?? 0.0;
    return LatLng(lat, lng);
  }

  LatLng get pickupLatLng {
    double lat = double.tryParse(requestBody.value.dropLatitude ?? "0.0") ?? 0.0;
    double lng = double.tryParse(requestBody.value.dropLongitude ?? "0.0") ?? 0.0;
    return LatLng(lat, lng);
  }

  @override
  void onInit() {
    super.onInit();
    socketService.addListener(this);
    loadCustomIcons();
    getRequestDetail();
  }

  @override
  void onClose() {
    socketService.removeListener(this);
    super.onClose();
  }

  Future<void> loadCustomIcons() async {
    driverIcon = await getBytesFromAsset(Assets.icons.car.path, 100);
    update();
  }

  Future<BitmapDescriptor> getBytesFromAsset(String path, int width) async {
    final targetWidth = Platform.isIOS ? width * 1.5 : width * 1.5;

    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: targetWidth.toInt(),
      targetHeight: targetWidth.toInt(),
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    final bytes = (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(bytes);
  }

  Future<void> getRequestDetail() async {
    final Map<String, dynamic> map = {
      "lostItemId": Get.arguments?["requestId"] ?? ""
    };
    var response = await ApiProvider().lostItemRequestDetail(map, true);
    if (response.success == true) {
      requestBody.value = response.body ?? LostItemRequestDetail();
      fetchRoute();
    }
  }

  Future<void> fetchRoute() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: ApiConstants.placesKey,
      request: PolylineRequest(
        origin: PointLatLng(pickupLatLng.latitude, pickupLatLng.longitude),
        destination: PointLatLng(dropOffLatLng.latitude, dropOffLatLng.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      List<LatLng> coords = result.points.map((p) => LatLng(p.latitude, p.longitude)).toList();
      polylines.value = {
        Polyline(
          polylineId: const PolylineId("lost_item_route"),
          color: Colors.black,
          points: coords,
          width: 5,
        ),
      };
      _updateCamera(coords);
    }
  }

  void _updateCamera(List<LatLng> points) {
    if (points.isEmpty) return;
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        points.map((p) => p.latitude).reduce((a, b) => a < b ? a : b),
        points.map((p) => p.longitude).reduce((a, b) => a < b ? a : b),
      ),
      northeast: LatLng(
        points.map((p) => p.latitude).reduce((a, b) => a > b ? a : b),
        points.map((p) => p.longitude).reduce((a, b) => a > b ? a : b),
      ),
    );
    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
  }

  @override
  void onSocketEvent(data, String eventType) {
    if (eventType == 'startNavigation') {
      try {
        print("ROUTE STATUSS: $data");
        getRequestDetail();
      } catch (e) {
        print("Error parsing update_route_listener socket data: $e");
      }
    }
  }

}