import 'package:get/get.dart';

class ContentController extends GetxController {
  // var content = Body().obs;

  @override
  void onInit() {
    super.onInit();
    // getContent();
  }

 /* Future<void> getContent() async {
    final type = Get.arguments?['from'] == 'privacy' ? 1 : Get.arguments?['from'] == 'about' ? 2 : 3;
    var response = await ApiProvider().cms(type);
    if (response.success == true) {
      content.value = response.body ?? Body();
    } else {
      Utils.showErrorToast(message: response.message ?? "");
    }
  }*/
}
