import 'dart:ffi';

import 'package:carry_you_user/model/review_listing_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/apputills.dart';
import '../model/booking_detail_response.dart';
import '../network/api_provider.dart';
import '../routes/app_routes.dart';

class ReviewController extends GetxController {
  RxList<ReviewBody> reviewBody = RxList();
  String driverId = "";

  @override
  void onInit() {
    super.onInit();
    driverId = Get.arguments?["driverId"] ?? "";
    reviews();
  }

  Future<void> reviews() async {
    Map<String, dynamic> body = {
      "driverId": driverId,
    };
    var response = await ApiProvider().getReviewListing(body, true);
    if (response.success == true) {
      reviewBody.clear();
      reviewBody.assignAll(response.body ?? []);
    } else {
      Utils.showErrorToast(message: response.message);
    }
  }
}
