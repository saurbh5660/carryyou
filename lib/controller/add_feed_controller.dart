import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/camera_helper.dart';

class AddFeedController extends GetxController implements CameraOnCompleteListener {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController hashtagController = TextEditingController();

  // List to hold selected image paths
  var selectedImages = <String>[].obs;
  late CameraHelper cameraHelper;

  @override
  void onInit() {
    super.onInit();
    cameraHelper = CameraHelper(this);
  }

  void pickImage() {
    cameraHelper.openImagePicker(0);
  }

  @override
  void onSuccessFile(String file, String fileType, int code) {
    if (fileType == "image") {
      selectedImages.add(file);
    }
  }

  @override
  void onSuccessVideo(String selectedUrl, Uint8List? thumbnail) {
    // Handle video if needed
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }
}