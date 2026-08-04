import 'package:get/get.dart';
import '../../model/booking_detail_response.dart';
import '../../network/api_provider.dart';
import 'package:intl/intl.dart';

class RideDetailController extends GetxController {
  var isLoading = true.obs;
  var rideDetail = BookingDetailBody().obs;
  String bookingId = "";

  @override
  void onInit() {
    super.onInit();
    bookingId = Get.arguments['bookingId'] ?? "";
    getRideDetails();
  }

  Future<void> getRideDetails() async {
    isLoading.value = true;
    try {
      var response = await ApiProvider().bookingDetail({"bookingId": bookingId}, false);
      if (response.success == true && response.body != null) {
        rideDetail.value = response.body!;
      }
    } finally {
      isLoading.value = false;
    }
  }

  String formatDate(String? dateStr) {
    if (dateStr == null) return "";
    DateTime dt = DateTime.parse(dateStr).toLocal();
    return DateFormat('MMM d h:mm a').format(dt);
  }
}