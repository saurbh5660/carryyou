import 'package:carry_you_user/controller/activity_controller.dart';
import 'package:carry_you_user/controller/ride_detail_controller.dart';
import 'package:get/get.dart';
import '../controller/common_controller.dart';
import '../controller/dashboard_controller.dart';
import '../controller/reset_password_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CommonController());
  }
}

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
  }
}

class ResetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ResetPasswordController());
  }
}

class ActivityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ActivityController());
  }
}

class RideDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RideDetailController());
  }
}
