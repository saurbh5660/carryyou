import 'package:carry_you_user/common/apputills.dart';
import 'package:carry_you_user/model/lost_item_response.dart';
import 'package:carry_you_user/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import '../common/google_places_picker.dart';
import '../network/api_provider.dart';

enum LostItemStatus { reporting, contactOptions, arrangingReturn, escalated, completed }

class LostItemController extends GetxController {
  var currentStatus = LostItemStatus.reporting.obs;
  var lostItemId = "";

  LostItem? lostItem;

  var selectedDialCode = "+1".obs;
  var selectedFlag = "🇺🇸".obs;

  final descController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  var driverName = "Rajesh".obs;
  var calculatedFee = 15.0.obs;
  var dropLat = '0.0';
  var dropLng = '0.0';
  var dropLocation = "";

  @override
  void onInit() {
    super.onInit();
    lostItem = Get.arguments?["item"] ?? LostItem();
    if(lostItem?.id != null){
      Logger().d("zbbdxhdf--------------"+lostItem!.id.toString());
      lostItemId = lostItem?.id ?? "";
      if(lostItem?.userConfirm == 0 && lostItem?.driverConfirm == 0 && lostItem?.sendToAdminOrNot == 0){
        currentStatus.value = LostItemStatus.contactOptions;
      }else if((lostItem?.userConfirm == 1 || lostItem?.driverConfirm == 1) && lostItem?.paymentStatus == 0){
        currentStatus.value = LostItemStatus.arrangingReturn;
      }
      else if(lostItem?.sendToAdminOrNot == 1){
        currentStatus.value = LostItemStatus.escalated;
      }else if(lostItem?.paymentStatus == 1){
        currentStatus.value = LostItemStatus.completed;
      }
    }
  }

  void validSubmitRequest(String desc, String phone) {
    if(desc.isEmpty){
      Utils.showErrorToast(message: "Please enter description.");
      return;
    }

    if(phone.isEmpty){
      Utils.showErrorToast(message: "Please enter phone number.");
      return;
    }

    if(phone.length < 7){
      Utils.showErrorToast(message: "Please enter valid phone number.");
      return;
    }
    submitRequest();
  }

  Future<void> submitRequest() async {
    Map<String,dynamic> map = {
      "bookingId" : Get.arguments?["bookingId"] ?? "",
      "driverId" : Get.arguments?["driverId"] ?? "",
      "description" : descController.text.toString(),
      "countryCode" : selectedDialCode.value,
      "phoneNumber" : phoneController.text.toString(),
    };
    var response = await ApiProvider().submitLostItemRequest(map,true);
    Logger().d(response);
    if (response.success == true) {
      currentStatus.value = LostItemStatus.contactOptions;
      lostItemId = response.body?.id ?? "";
    } else {
      Utils.showErrorToast(message: response.message);
    }
  }

  Future<void> driverFoundItemConfirmUser() async {
    Map<String,dynamic> map = {
      "lostItemId" : lostItemId,
    };
    var response = await ApiProvider().driverFoundItemConfirmByUser(map,true);
    Logger().d(response);
    if (response.success == true) {
      currentStatus.value = LostItemStatus.arrangingReturn;
    } else {
      Utils.showErrorToast(message: response.message);
    }
  }

  Future<void> sendRequestToAdmin() async {
    Map<String,dynamic> map = {
      "lostItemId" : lostItemId,
    };
    var response = await ApiProvider().sendRequestToAdmin(map,true);
    Logger().d(response);
    if (response.success == true) {
      currentStatus.value = LostItemStatus.escalated;
    } else {
      Utils.showErrorToast(message: response.message);
    }
  }

  Future<void> payAmountLostItem() async {
    if(dropLocation.isEmpty){
      Utils.showErrorToast(message: "Please enter item drop location.");
      return;
    }

    Map<String,dynamic> map = {
      "lostItemId" : lostItemId,
      "amount" : "20",
      "bookingId" : Get.arguments?["bookingId"] ?? "",
      "dropLatitude" : dropLat,
      "dropLongitude" : dropLng,
      "dropLocation" : dropLocation,
    };
    var response = await ApiProvider().payAmountLostItem(map,true);
    Logger().d(response);
    if (response.success == true) {
      Stripe.publishableKey = "pk_test_51ROCVqPR0LipSHIytuyQNFhaZMGngeu4jmIH2Zg6EI5Mq43AwRv4lShP39VaFk4mpBTnAeWhDIjmq3flfl1FAGK900bI92msNX";
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: response.body?.paymentIntent?.clientSecret ?? "",
          customerEphemeralKeySecret: response.body?.ephemeralKey ?? "",
          customerId: response.body?.customer ?? "",
          merchantDisplayName: "CarryU",
        ),
      );
      try {
        await Stripe.instance.presentPaymentSheet();
        bool isConfirmed = await bookingConfirmation(response.body?.transactionId ?? "");
        if (isConfirmed) {
          Get.offNamed(AppRoutes.lostItemMapScreen,arguments: {"requestId":lostItemId});
          // currentStatus.value = LostItemStatus.completed;
        }
      } catch (e) {
        Utils.showErrorToast(message: "Payment Cancelled");
      }
    } else {
      Utils.showErrorToast(message: response.message);
    }
  }

  void callDriver() async {
    final Uri url = Uri.parse('tel:${Get.arguments?["phone"] ?? ""}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> openPlacePicker() async {
    var result = await Get.to(() => const GooglePlacePickerScreen());
    if (result != null && result is Map) {
      addressController.text = result["address"] ?? "";
      dropLocation = result["address"] ?? "";
      dropLat = result["lat"] ?? '0.0';
      dropLng = result["lng"] ?? '0.0';
      updateCalculation(addressController.text);
    }
  }
  void onCouldNotReach() => currentStatus.value = LostItemStatus.escalated;

  void updateCalculation(String address) {
    if (address.isNotEmpty) {
      // Simulate calculation logic
      calculatedFee.value = 10.0 + (address.length / 10);
    }
  }

  void processReturn(String address) {
    if (address.isEmpty) {
      Get.snackbar("Error", "Please select a drop-off location");
      return;
    }
    currentStatus.value = LostItemStatus.completed;
  }

  Future<bool> bookingConfirmation(String transactionId) async {
    var response = await ApiProvider().bookingLostItemConfirmation({"transactionId": transactionId});
    return response.success ?? false;
  }

}