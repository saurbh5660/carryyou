import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../common/camera_helper.dart';

class LicenseDetailController extends GetxController  implements CameraOnCompleteListener {
  final licenseFront = RxnString();
  final licenseBack = RxnString();

  late CameraHelper cameraHelper;

  TextEditingController licenseNoController = TextEditingController();
  TextEditingController issuedOnController = TextEditingController();
  TextEditingController licenseTypeController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController expiryController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    cameraHelper = CameraHelper(this);
  }


  @override
  void onSuccessFile(String file, String fileType, int code) {
    if (file.isNotEmpty) {
      if (code == 1) licenseFront.value = file;
      if (code == 2) licenseBack.value = file;
    }
  }

  @override
  void onSuccessVideo(String selectedUrl, Uint8List? thumbnail) {

  }


}
