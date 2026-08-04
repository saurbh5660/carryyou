import 'package:get/get.dart';

import '../model/banner_list_response.dart';
import '../network/api_provider.dart';

class BannerController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<BannerItem> banners = <BannerItem>[].obs;
  final RxString errorMessage = ''.obs;

  final ApiProvider _apiProvider = ApiProvider();

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
  }

  Future<void> fetchBanners() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final parsed = await _apiProvider.getBannerList(showLoader: false);
      banners.assignAll(parsed.body ?? const <BannerItem>[]);
    } catch (e) {
      errorMessage.value = e.toString();
      banners.clear();
    } finally {
      isLoading.value = false;
    }
  }
}

