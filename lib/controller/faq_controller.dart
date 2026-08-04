import 'package:get/get.dart';

class FaqController extends GetxController {
   // RxList<FaqData> data = RxList();

  @override
  void onInit() {
    super.onInit();
    // getFaq();
  }

 /* Future<void> getFaq() async {
    var response = await ApiProvider().faq();
    if (response.success == true) {
      data.clear();
      data.value = (response.body ?? []).reversed.toList();
    } else {
      Utils.showErrorToast(message: response.message ?? "");
    }
  }*/
}
