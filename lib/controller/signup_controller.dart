import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../common/apputills.dart';
import '../common/camera_helper.dart';
import '../common/db_helper.dart';
import '../network/api_provider.dart';
import '../routes/app_routes.dart';

class SignupController extends GetxController
    implements CameraOnCompleteListener {
  Rx<bool> passwordVisibility = true.obs;
  Rx<bool> confirmPasswordVisibility = true.obs;
  var isSwitchActive = false.obs;
  var isPrivacySwitchActive = false.obs;

  late CameraHelper cameraHelper;
  final profileImage = RxnString();
  RxString selectedDialCode = "+1".obs;
  RxString selectedFlag = "🇺🇸".obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController referralController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    cameraHelper = CameraHelper(this);
  }

  @override
  void onSuccessFile(String file, String fileType, int code) {
    if (file.isNotEmpty) {
      profileImage.value = file;
    }
  }

  @override
  void onSuccessVideo(String selectedUrl, Uint8List? thumbnail) {}

  validationSignup() async {
    if (profileImage.value == null) {
      Utils.showErrorToast(message: "Please select profile image.");
      return;
    }
    if (nameController.text.trim().isEmpty) {
      Utils.showErrorToast(message: "Please enter full name.");
      return;
    }

    if (emailController.text.trim().isEmpty) {
      Utils.showErrorToast(message: "Please enter email.");
      return;
    }
    if (!emailController.text.trim().isEmail) {
      Utils.showErrorToast(message: "Please enter valid email.");
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      Utils.showErrorToast(message: "Please enter phone number.");
      return;
    }

    if (phoneController.text.trim().length < 7) {
      Utils.showErrorToast(message: "Please enter valid phone number.");
      return;
    }

    if (cityController.text.trim().isEmpty) {
      Utils.showErrorToast(message: "Please enter city.");
      return;
    }

    if (countryController.text.trim().isEmpty) {
      Utils.showErrorToast(message: "Please enter country.");
      return;
    }

    if (passwordController.text.trim().isEmpty) {
      Utils.showErrorToast(message: "Please enter password.");
      return;
    }

    if (passwordController.text.trim().length < 6) {
      Utils.showErrorToast(
        message: "Password must be at least 6 characters long.",
      );
      return;
    }

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      Utils.showErrorToast(
        message: "Password and Confirm Password do not match.",
      );
      return;
    }

    if (!isSwitchActive.value) {
      Utils.showErrorToast(message: "Please accept terms & conditions.");
      return;
    }

    if (!isPrivacySwitchActive.value) {
      Utils.showErrorToast(message: "Please accept privacy policy.");
      return;
    }

    signupApi();
  }

  Future<void> signupApi() async {
    String token = "";
    /* if (deviceToken.isEmpty) {
      token = "dddd";
    } else {
      token = deviceToken;
    }*/
    Map<String, dynamic> userData = {
      "fullName": nameController.text.trim(),
      "email": emailController.text.trim(),
      "countryCode": selectedDialCode.value,
      "phoneNumber": phoneController.text.trim(),
      "city": cityController.text.trim(),
      "country": countryController.text.trim(),
      "password": passwordController.text.trim(),
      "deviceToken": "jsfjsdfsdj",
      "role": "1",
      "deviceType": Platform.isAndroid ? "1" : "2",
    };

    var response = await ApiProvider().signUpApi(
      userData,
      profileImage.value ?? "",
    );
    Logger().d(response);
    if (response.success == true) {
      Utils.showSuccessToast(message: "Your static otp is 1111.");
      DbHelper().saveUserModel(response.body);
      DbHelper().saveUserToken(response.body?.token ?? "");
      Get.toNamed(
        AppRoutes.verificationScreen,
        arguments: {
          'email': emailController.text.toString(),
          'countryCode': selectedDialCode.toString(),
          'phone': phoneController.text.toString(),
          'from': "signup",
        },
      );
    } else {
      Utils.showErrorToast(message: response.message);
    }
  }

  Future<void> otpVerify() async {
    if (otpController.text.trim().length != 4) {
      Utils.showErrorToast(message: "Please enter 4 digit otp.");
      return;
    }

    Map<String, dynamic> userData = {
      "email": Get.arguments?["email"] ?? "",
      // "countryCode": Get.arguments?["countryCode"] ?? "",
      // "phoneNumber": Get.arguments?["phone"] ?? "",
      "otp": otpController.text.trim(),
    };

    var response = await ApiProvider().otpVerify(userData);
    Logger().d(response);
    if (response.success == true) {
      DbHelper().saveUserModel(response.body);
      DbHelper().saveUserToken(response.body?.token ?? "");
      DbHelper().saveIsLoggedIn(true);
      Get.toNamed(AppRoutes.homeScreen);
    } else {
      Utils.showErrorToast(message: response.message);
    }
  }

  Future<void> otpResend() async {
    Map<String, dynamic> userData = {
      "email": Get.arguments?["email"] ?? "",
      // "countryCode": Get.arguments?["countryCode"] ?? "",
      // "phoneNumber": Get.arguments?["phone"] ?? "",
    };
    var response = await ApiProvider().otpResend(userData);
    Logger().d(response);
    if (response.success == true) {
      Utils.showSuccessToast(message: 'OTP Resend successfully');
    } else {
      Utils.showErrorToast(message: response.message);
    }
  }
}
