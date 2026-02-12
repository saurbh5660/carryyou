import 'dart:typed_data';

import 'package:carry_you_user/network/api_constants.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/apputills.dart';
import '../common/camera_helper.dart';
import '../common/db_helper.dart';
import '../model/profile_response.dart';
import '../network/api_provider.dart';

class EditProfileController extends GetxController implements CameraOnCompleteListener {
  late CameraHelper cameraHelper;
  final profileImage = RxnString();
  RxString selectedDialCode = "+1".obs;
  RxString selectedFlag = "🇮🇳".obs;
  Rx<ProfileBody> profileBody = Rx(ProfileBody());
  final TextEditingController nameController = TextEditingController(text: "");
  final TextEditingController emailController = TextEditingController(text: "");
  final TextEditingController phoneController = TextEditingController(text: "");

  @override
  onInit(){
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


  Future<void> getProfile() async {
    try {
      var response = await ApiProvider().getProfile();
      if (response.success == true) {
        profileBody.value = response.body ?? ProfileBody();
        profileImage.value = ApiConstants.userImageUrl+(profileBody.value.profilePicture ?? "");
        nameController.text = profileBody.value.fullName ?? "";
        emailController.text = profileBody.value.email ?? "";
        phoneController.text = profileBody.value.phoneNumber ?? "";
        selectedDialCode.value = profileBody.value.countryCode ?? "";

        String countryCode = profileBody.value.countryCode ?? "+1";
        selectedDialCode.value = countryCode;
        String cleanCode = countryCode.replaceAll('+', '');
        try {
          Country? country = CountryParser.parsePhoneCode(cleanCode);
          selectedFlag.value = country.flagEmoji;
        } catch (e) {
          selectedFlag.value = "🏳️";
        }
      } else {
        Utils.showErrorToast(message: response.message ?? "");
      }
    } catch (e) {
      Utils.showErrorToast(message: "An error occurred: $e");
    }
  }


  validationEdit() async {
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

    updateApi();
  }

  Future<void> updateApi() async {
    Map<String, dynamic> userData = {
      "fullName": nameController.text.trim(),
      "email": emailController.text.trim(),
      "countryCode": selectedDialCode.value,
      "phoneNumber": phoneController.text.trim(),
    };

    var response = await ApiProvider().updateProfile(
      userData,
      profileImage.value ?? "",
    );
    if (response.success == true) {
      DbHelper().saveUserModel(response.body);
      Get.back();
    } else {
      Utils.showErrorToast(message: response.message);
    }
  }

}
