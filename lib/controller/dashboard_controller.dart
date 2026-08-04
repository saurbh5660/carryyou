import 'package:get/get.dart';
class DashboardController extends GetxController {
  final currentIndex = RxInt(0);

  @override
  void onInit() {
    super.onInit();
  }

  void onChangeIndex(int index) {
    currentIndex.value = index;
  }
}
