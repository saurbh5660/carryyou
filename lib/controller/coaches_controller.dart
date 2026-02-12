import 'package:get/get.dart';

class CoachesController extends GetxController {
  final pageIndex = 0.obs;


  void onPageChanged(int index) {
    pageIndex.value = index;
  }

}
