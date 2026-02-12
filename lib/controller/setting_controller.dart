import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  var isNotificationEnabled = true.obs;
  TextEditingController referralController = TextEditingController(text: 'OcYMGlobal1234');

  @override
  void onInit() {
    super.onInit();
   /* final user = DbHelper().getUserModel();
    if ((user?.isnotification ?? 0) == 1) {
      isNotificationEnabled.value = true;
    } else {
      isNotificationEnabled.value = false;
    }*/
  }

  void toggleNotification(bool value) {
    isNotificationEnabled.value = value;
    // notificationStatus(isNotificationEnabled.value == true ? 1 : 0);
  }

 /* Future<void> notificationStatus(int status) async {
    Map<String, dynamic> userData = {"isnotification": status};
    var response = await ApiProvider().notificationStatus(userData);
    if (response.success == true) {
    } else {
      isNotificationEnabled.value == !isNotificationEnabled.value;
      Utils.showErrorToast(message: response.message ?? "");
    }
  }*/

  /*Future<void> logout() async {
    var response = await ApiProvider().logout();
    if (response.success == true) {
      DbHelper().clearAll();
      Get.back();
      Get.offAllNamed(AppRoutes.loginView);
    } else {
      Utils.showErrorToast(message: response.message ?? "");
    }
  }

  Future<void> deleteAccount() async {
    var response = await ApiProvider().deleteAccount();
    if (response.success == true) {
      DbHelper().clearAll();
      Get.back();
      Get.offAllNamed(AppRoutes.loginView);
    } else {
      Utils.showErrorToast(message: response.message ?? "");
    }
  }*/
}
