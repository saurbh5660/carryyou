import 'package:get/get.dart';
import '../common/apputills.dart';
import '../model/notification_list_response.dart';
import '../network/api_provider.dart';

class NotificationController extends GetxController {
  RxList<NotificationBody> notificationList = RxList();

  Future<void> getNotificationList() async {
    var response = await ApiProvider().getNotificationList();
    if (response.success == true) {
      notificationList.clear();
      notificationList.assignAll(response.body ?? []);
    } else {
      Utils.showErrorToast(message: response.message ?? "");
    }
  }
}
