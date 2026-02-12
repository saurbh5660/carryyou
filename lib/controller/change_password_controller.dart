import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../common/camera_helper.dart';

class ChangePasswordController extends GetxController {
  Rx<bool> oldPasswordVisibility = true.obs;
  Rx<bool> passwordVisibility = true.obs;
  Rx<bool> confirmPasswordVisibility = true.obs;


  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();


}
