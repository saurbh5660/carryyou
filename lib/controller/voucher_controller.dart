import 'package:get/get.dart';
import '../common/apputills.dart';
import '../model/coupon_code_response.dart';
import '../model/notification_list_response.dart';
import '../network/api_provider.dart';

class VoucherController extends GetxController {
  RxList<CouponBody> couponList = RxList();

  Future<void> getCouponList() async {
    var response = await ApiProvider().getCouponList();
    if (response.success == true) {
      couponList.clear();
      couponList.assignAll(response.body ?? []);
    } else {
      Utils.showErrorToast(message: response.message ?? "");
    }
  }
}
