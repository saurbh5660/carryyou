import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../common/apputills.dart';
import '../model/booking_list_response.dart';
import '../network/api_provider.dart';

class ActivityController extends GetxController {
  var ongoingRides = <Body>[].obs;
  var upcomingRides = <Body>[].obs;
  var pastRides = <Body>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getBookingList();
  }

  Future<void> getBookingList() async {
    isLoading.value = true;
    try {
      // Call your existing API provider method
      BookingListResponse response = await ApiProvider().bookingList(false);

      if (response.success == true && response.body != null) {
        ongoingRides.clear();
        upcomingRides.clear();
        pastRides.clear();

        for (var item in response.body!) {
          int status = item.status ?? 0;

          // STATUS LOGIC:
          // Ongoing: 1 (Accepted), 4 (Started), 5 (Reached)
          if ((item.scheduleType == 1 && status == 0) || status == 1 || status == 4 || status == 5) {
            ongoingRides.add(item);
          }
          // Upcoming: scheduleType 2 (Scheduled) and status 0 (Pending)
          else if (item.scheduleType == 2 && status == 0) {
            upcomingRides.add(item);
          }
          // Past: 3 (User Cancel), 6 (Completed), 7 (Driver Cancel)
          else {
            pastRides.add(item);
          }
        }
      }
    } catch (e) {
      Utils.showErrorToast(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  String getStatusText(int? status) {
    switch (status) {
      case 1: return "Driver Accepted";
      case 3: return "Cancelled by you";
      case 4: return "Ride Started";
      case 5: return "Driver Arrived";
      case 6: return "Completed";
      case 7: return "Cancelled by Driver";
      default: return "Pending";
    }
  }

  String formatDate(String? dateStr) {
    if (dateStr == null) return "";
    try {
      DateTime dt = DateTime.parse(dateStr).toLocal();
      return DateFormat('MMM dd • hh:mm a').format(dt);
    } catch (e) {
      return dateStr;
    }
  }
}