import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../common/apputills.dart';
import '../common/db_helper.dart';
import '../network/api_provider.dart';
import '../routes/app_routes.dart';

class CommonController extends GetxController {
  Rx<bool> passwordVisibility = true.obs;
  var isSwitchActive = false.obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController referralController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();


  void onSwitchChanged(bool value) {
    isSwitchActive.value = value;
  }

  validationLogin() async {
    if (emailController.text.trim().isEmpty) {
      Utils.showErrorToast(message: "Please enter email.");
      return;
    }
    if (!emailController.text.trim().isEmail) {
      Utils.showErrorToast(message: "Please enter valid email.");
      return;
    }

    if (passwordController.text.trim().isEmpty) {
      Utils.showErrorToast(message: "Please enter password.");
      return;
    }

    loginApi();
  }

  Future<void> loginApi() async {
    String token = "";
    /* if (deviceToken.isEmpty) {
      token = "dddd";
    } else {
      token = deviceToken;
    }*/
    Map<String, dynamic> userData = {
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "deviceToken": "hshhsvfds",
      "role": "1",
      "deviceType": Platform.isAndroid ? "1" : "2",
    };

    var response = await ApiProvider().loginApi(userData);
    Logger().d(response);
    if (response.success == true) {
      DbHelper().saveUserModel(response.body);
      DbHelper().saveUserToken(response.body?.token ?? "");
      if (response.body?.isOtpVerified != 1) {
        Get.toNamed(
          AppRoutes.verificationScreen,
          arguments: {
            'email': emailController.text.toString(),
            'countryCode': response.body?.countryCode.toString(),
            'phone': response.body?.phoneNumber.toString(),
            'from': "login",
          },
        );
        return;
      }
      DbHelper().saveIsLoggedIn(true);
      Get.offAllNamed(AppRoutes.homeScreen);
    } else {
      Utils.showErrorToast(message: response.message);
    }
  }

}
