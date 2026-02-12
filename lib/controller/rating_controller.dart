import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/apputills.dart';
import '../model/booking_detail_response.dart';
import '../network/api_provider.dart';
import '../routes/app_routes.dart';

class RatingController extends GetxController {
  Rx<BookingDetailBody> requestBody = Rx(BookingDetailBody());
  var isLoading = false.obs;
  double selectedStars = 4.0;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments["detail"] != null) {
      requestBody.value = Get.arguments["detail"];
    }
  }

  Future<void> submitRating({required double rating, required String comment}) async {
    try {
      isLoading.value = true;
      Map<String, dynamic> body = {
        // "booking_id": requestBody.value.id,
        // "driver_id": requestBody.value.driver?.id,
        "rating": rating,
        // "comment": comment,
      };

      var response = await ApiProvider().addRating(
        body,
        false,
      );
      if (response.success == true) {
        Get.offAllNamed(AppRoutes.homeScreen);
      } else {
        Utils.showErrorToast(message: response.message);
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Utils.showErrorToast(message: "Failed to add rating.");
    }
  }
}