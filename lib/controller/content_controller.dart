import 'package:get/get.dart';
import '../common/apputills.dart';
import '../model/cms_response.dart';
import '../network/api_provider.dart';

class ContentController extends GetxController {
  var isLoading = true.obs;
  var cmsData = Rxn<CmsData>();

  @override
  void onInit() {
    super.onInit();
    final String type = Get.arguments?['type']?.toString() ??
        (Get.arguments?['from'] == 'privacy'
            ? 'privacy_policy'
            : 'driver_terms');
    fetchCmsContent(type);
  }

  int getDownloadType(String? currentType) {
    if (currentType == '1' || currentType == 'about_us') return 1;
    if (currentType == '2' || currentType == 'privacy_policy' || currentType == 'privacy') return 2;
    // Default: 3 for terms and conditions (driver_terms, terms, 3)
    return 3;
  }

  Future<void> fetchCmsContent(String type) async {
    isLoading.value = true;
    final int typeInt = getDownloadType(type);
    try {
      var response = await ApiProvider().cmsContentApi(typeInt);
      if (response.success == true && response.body != null) {
        cmsData.value = response.body;
      } else {
        cmsData.value = null;
        if (response.message != null && response.message!.isNotEmpty) {
          Utils.showErrorToast(message: response.message!);
        }
      }
    } catch (e) {
      cmsData.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> fetchDownloadPdfUrl(String? currentType) async {
    final int typeInt = getDownloadType(currentType);
    try {
      var response = await ApiProvider().cmsDownloadPdfApi(typeInt);
      if (response.success == true && response.body?.pdfUrl != null && response.body!.pdfUrl!.isNotEmpty) {
        return response.body?.pdfUrl;
      }
    } catch (_) {}
    return null;
  }
}
