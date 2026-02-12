import 'package:get/get.dart';
import '../common/apputills.dart';
import '../model/profile_response.dart';
import '../network/api_provider.dart';

class ProfileController extends GetxController {
  Rx<ProfileBody> profileBody = Rx(ProfileBody());


  Future<void> getProfile() async {
    try {
      var response = await ApiProvider().getProfile();
      if (response.success == true) {
        profileBody.value = response.body ?? ProfileBody();
      } else {
        Utils.showErrorToast(message: response.message ?? "");
      }
    } catch (e) {
      Utils.showErrorToast(message: "An error occurred: $e");
    }
  }
}
