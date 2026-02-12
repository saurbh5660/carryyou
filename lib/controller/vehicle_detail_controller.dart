import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/camera_helper.dart';

class VehicleDetailController extends GetxController implements CameraOnCompleteListener {
  late CameraHelper cameraHelper;

  final vehicleImage = RxnString();
  final registrationImage = RxnString();
  final insuranceImage = RxnString();

  TextEditingController registrationExpiryController = TextEditingController();
  TextEditingController insuranceExpiryController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();

  RxString selectedVehicleType = "".obs;

  @override
  void onInit() {
    super.onInit();
    cameraHelper = CameraHelper(this);
  }

  @override
  void onSuccessFile(String file, String fileType, int code) {
    if (file.isNotEmpty) {
      if (code == 1) vehicleImage.value = file;
      if (code == 2) registrationImage.value = file;
      if (code == 3) insuranceImage.value = file;
    }
  }

  @override
  void onSuccessVideo(String selectedUrl, Uint8List? thumbnail) {}
}