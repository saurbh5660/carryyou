import 'package:carry_you_user/model/booking_list_response.dart';
import 'package:carry_you_user/model/coupon_code_response.dart';
import 'package:carry_you_user/model/create_booking_response.dart';
import 'package:carry_you_user/model/lost_item_payment_response.dart';
import 'package:carry_you_user/model/lost_item_request_response.dart';
import 'package:carry_you_user/model/profile_response.dart';
import 'package:carry_you_user/model/review_listing_response.dart';
import 'package:carry_you_user/model/signup_response.dart';
import 'package:carry_you_user/model/vehicle_type_response.dart';
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';
import 'package:mime_type/mime_type.dart';
import '../common/apputills.dart';
import '../model/banner_list_response.dart';
import '../model/booking_detail_response.dart';
import '../model/common_response.dart';
import '../model/lost_item_request_detail_response.dart';
import '../model/notification_list_response.dart';
import '../model/promo_code_response.dart';
import '../model/cms_response.dart';
import '../model/cms_pdf_response.dart';
import 'api_constants.dart';
import 'base_client.dart';
import 'package:dio/dio.dart' as dio;

class ApiProvider {
  static late BaseClient _baseClient;
  final logger = Logger();

  ApiProvider() {
    _baseClient = BaseClient();
    _baseClient.init();
  }

  Future<CmsResponse> cmsContentApi(int type) async {
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.usersCms,
      requestType: RequestType.post,
      body: {"type": type.toString()},
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      return CmsResponse.fromJson(response);
    } catch (e) {
      final res = (e as dynamic).response;
      if (res != null) {
        return CmsResponse.fromJson(res?.data);
      }
      return CmsResponse(message: e.toString());
    }
  }

  Future<CmsResponse> cms(int type) async {
    Utils.showLoading();
    String urlWithParams = "${ApiConstants.cms}/$type";
    ApiRequest apiRequest = ApiRequest(
      url: urlWithParams,
      requestType: RequestType.get,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return CmsResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return CmsResponse.fromJson(res?.data);
      }
      return CmsResponse(message: e.toString());
    }
  }

  Future<CmsResponse> getCmsContentApi(String type) async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: "${ApiConstants.getCmsContent}?type=$type",
      requestType: RequestType.get,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return CmsResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return CmsResponse.fromJson(res?.data);
      }
      return CmsResponse(message: e.toString());
    }
  }

  Future<CmsPdfResponse> cmsDownloadPdfApi(int type) async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: "${ApiConstants.cmsDownloadPdf}?type=$type",
      requestType: RequestType.get,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return CmsPdfResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return CmsPdfResponse.fromJson(res?.data);
      }
      return CmsPdfResponse(message: e.toString());
    }
  }

  Future<SignupResponse> loginApi(Map<String, dynamic> body) async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.login,
      requestType: RequestType.post,
      body: body,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return SignupResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return SignupResponse.fromJson(res?.data);
      }
      return SignupResponse(message: e.toString());
    }
  }

  Future<SignupResponse> signUpApi(
    Map<String, dynamic> body,
    String image,
  ) async {
    Utils.showLoading();
    if (image.isNotEmpty && !(image.startsWith("http"))) {
      body['profilePicture'] = await getMultipart(path: image);
    }
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.signUp,
      requestType: RequestType.post,
      body: body,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return SignupResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return SignupResponse.fromJson(res?.data);
      }
      return SignupResponse(message: e.toString());
    }
  }

  Future<SignupResponse> otpVerify(Map<String, dynamic> body) async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.otpVerify,
      requestType: RequestType.post,
      body: body,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return SignupResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return SignupResponse.fromJson(res?.data);
      }
      return SignupResponse(message: e.toString());
    }
  }

  Future<SignupResponse> otpResend(Map<String, dynamic> body) async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.otpResend,
      requestType: RequestType.post,
      body: body,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return SignupResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return SignupResponse.fromJson(res?.data);
      }
      return SignupResponse(message: e.toString());
    }
  }

  Future<VehicleTypeResponse> getVehiclePrice(Map<String, dynamic> body) async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.getVehiclePrice,
      requestType: RequestType.post,
      body: body,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return VehicleTypeResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return VehicleTypeResponse.fromJson(res?.data);
      }
      return VehicleTypeResponse(message: e.toString());
    }
  }

  Future<NotificationListResponse> getNotificationList() async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.notificationsList,
      requestType: RequestType.get,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return NotificationListResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return NotificationListResponse.fromJson(res?.data);
      }
      return NotificationListResponse(message: e.toString());
    }
  }

  Future<BannerListResponse> getBannerList({bool showLoader = false}) async {
    if (showLoader) {
      Utils.showLoading();
    }
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.bannerList,
      requestType: RequestType.get,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      if (showLoader) {
        Utils.hideLoading();
      }
      return BannerListResponse.fromJson(response);
    } catch (e) {
      if (showLoader) {
        Utils.hideLoading();
      }
      final res = (e as dynamic).response;
      if (res != null) {
        return BannerListResponse.fromJson(res?.data);
      }
      return BannerListResponse(message: e.toString());
    }
  }

  Future<CouponCodeResponse> getCouponList() async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.couponCodeList,
      requestType: RequestType.get,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return CouponCodeResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return CouponCodeResponse.fromJson(res?.data);
      }
      return CouponCodeResponse(message: e.toString());
    }
  }

  Future<LostItemRequestDetailResponse> lostItemRequestDetail(
      Map<String, dynamic> body,
      bool showLoader
      ) async {
    if(showLoader){
      Utils.showLoading();
    }
    String queryString = Uri(queryParameters: body).query;
    String urlWithParams = "${ApiConstants.getLostItemRequestDetail}?$queryString";
    ApiRequest apiRequest = ApiRequest(
      url: urlWithParams,
      requestType: RequestType.get,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      if(showLoader){
        Utils.hideLoading();
      }
      return LostItemRequestDetailResponse.fromJson(response);
    } catch (e) {
      if(showLoader){
        Utils.hideLoading();
      }
      final res = (e as dynamic).response;
      if (res != null) {
        return LostItemRequestDetailResponse.fromJson(res?.data);
      }
      return LostItemRequestDetailResponse(message: e.toString());
    }
  }

  Future<ReviewListingResponse> getReviewListing(
      Map<String, dynamic> body,
      bool showLoader
      ) async {
    if(showLoader){
      Utils.showLoading();
    }
    String queryString = Uri(queryParameters: body).query;
    String urlWithParams = "${ApiConstants.reviewsListing}?$queryString";
    ApiRequest apiRequest = ApiRequest(
      url: urlWithParams,
      requestType: RequestType.get,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      if(showLoader){
        Utils.hideLoading();
      }
      return ReviewListingResponse.fromJson(response);
    } catch (e) {
      if(showLoader){
        Utils.hideLoading();
      }
      final res = (e as dynamic).response;
      if (res != null) {
        return ReviewListingResponse.fromJson(res?.data);
      }
      return ReviewListingResponse(message: e.toString());
    }
  }

  Future<CreateBookingResponse> createBooking(Map<String, dynamic> body) async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.createBooking,
      requestType: RequestType.post,
      body: body,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return CreateBookingResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return CreateBookingResponse.fromJson(res?.data);
      }
      return CreateBookingResponse(message: e.toString());
    }
  }

  Future<CreateBookingResponse> bookingConfirmation(Map<String, dynamic> body) async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.bookingConfirmation,
      requestType: RequestType.post,
      body: body,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return CreateBookingResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return CreateBookingResponse.fromJson(res?.data);
      }
      return CreateBookingResponse(message: e.toString());
    }
  }

  Future<BookingDetailResponse> bookingDetail(
      Map<String, dynamic> body,
      bool showLoader
      ) async {
    if(showLoader){
      Utils.showLoading();
    }
    String queryString = Uri(queryParameters: body).query;
    String urlWithParams = "${ApiConstants.bookingDetail}?$queryString";
    ApiRequest apiRequest = ApiRequest(
      url: urlWithParams,
      requestType: RequestType.get,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      if(showLoader){
        Utils.hideLoading();
      }
      return BookingDetailResponse.fromJson(response);
    } catch (e) {
      if(showLoader){
        Utils.hideLoading();
      }
      final res = (e as dynamic).response;
      if (res != null) {
        return BookingDetailResponse.fromJson(res?.data);
      }
      return BookingDetailResponse(message: e.toString());
    }
  }

    Future<BookingListResponse> bookingList(bool showLoader) async {
      if(showLoader){
        Utils.showLoading();
      }
      ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.bookingList,
        requestType: RequestType.get,
      );
      try {
        var response = await _baseClient.handleRequest(apiRequest);
        if(showLoader){
          Utils.hideLoading();
        }
        return BookingListResponse.fromJson(response);
      } catch (e) {
        if(showLoader){
          Utils.hideLoading();
        }
        final res = (e as dynamic).response;
        if (res != null) {
          return BookingListResponse.fromJson(res?.data);
        }
        return BookingListResponse(message: e.toString());
      }
    }

  Future<BookingDetailResponse> bookingStatusChange(
      Map<String, dynamic> body,
      bool showLoader
      ) async {
    if(showLoader){
      Utils.showLoading();
    }
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.bookingStatusChange,
        requestType: RequestType.post,
        body: body
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      if(showLoader){
        Utils.hideLoading();
      }
      return BookingDetailResponse.fromJson(response);
    } catch (e) {
      if(showLoader){
        Utils.hideLoading();
      }
      final res = (e as dynamic).response;
      if (res != null) {
        return BookingDetailResponse.fromJson(res?.data);
      }
      return BookingDetailResponse(message: e.toString());
    }
  }

  Future<BookingDetailResponse> bookingAcceptReject(
      Map<String, dynamic> body,
      bool showLoader
      ) async {
    if(showLoader){
      Utils.showLoading();
    }
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.bookingAcceptReject,
        requestType: RequestType.post,
        body: body
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      if(showLoader){
        Utils.hideLoading();
      }
      return BookingDetailResponse.fromJson(response);
    } catch (e) {
      if(showLoader){
        Utils.hideLoading();
      }
      final res = (e as dynamic).response;
      if (res != null) {
        return BookingDetailResponse.fromJson(res?.data);
      }
      return BookingDetailResponse(message: e.toString());
    }
  }

  Future<CommonResponse> deleteAccount() async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.deleteAccount,
      requestType: RequestType.post,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return CommonResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return CommonResponse.fromJson(res?.data);
      }
      return CommonResponse(message: e.toString());
    }
  }


  Future<CommonResponse> logout() async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.logout,
      requestType: RequestType.post,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return CommonResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return CommonResponse.fromJson(res?.data);
      }
      return CommonResponse(message: e.toString());
    }
  }


  Future<ProfileResponse> getProfile() async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.getUserDetail,
      requestType: RequestType.get,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return ProfileResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return ProfileResponse.fromJson(res?.data);
      }
      return ProfileResponse(message: e.toString());
    }
  }

  Future<SignupResponse> updateProfile(
      Map<String, dynamic> body,
      String image,
      ) async {
    Utils.showLoading();
    if (image.isNotEmpty && !(image.startsWith("http"))) {
      body['profilePicture'] = await getMultipart(path: image);
    }
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.updateProfile,
      requestType: RequestType.put,
      body: body,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return SignupResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return SignupResponse.fromJson(res?.data);
      }
      return SignupResponse(message: e.toString());
    }
  }

  Future<CommonResponse> addRating(
      Map<String, dynamic> body,
      bool showLoader
      ) async {
    if(showLoader){
      Utils.showLoading();
    }
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.ratingDriver,
        requestType: RequestType.post,
        body: body
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      if(showLoader){
        Utils.hideLoading();
      }
      return CommonResponse.fromJson(response);
    } catch (e) {
      if(showLoader){
        Utils.hideLoading();
      }
      final res = (e as dynamic).response;
      if (res != null) {
        return CommonResponse.fromJson(res?.data);
      }
      return CommonResponse(message: e.toString());
    }
  }

  Future<LostItemRequestResponse> submitLostItemRequest(
      Map<String, dynamic> body,
      bool showLoader
      ) async {
    if(showLoader){
      Utils.showLoading();
    }
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.submitLostItemRequestDriver,
        requestType: RequestType.post,
        body: body
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      if(showLoader){
        Utils.hideLoading();
      }
      return LostItemRequestResponse.fromJson(response);
    } catch (e) {
      if(showLoader){
        Utils.hideLoading();
      }
      final res = (e as dynamic).response;
      if (res != null) {
        return LostItemRequestResponse.fromJson(res?.data);
      }
      return LostItemRequestResponse(message: e.toString());
    }
  }

  Future<LostItemRequestResponse> driverFoundItemConfirmByUser(
      Map<String, dynamic> body,
      bool showLoader
      ) async {
    if(showLoader){
      Utils.showLoading();
    }
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.driverFoundItemConfimByUser,
        requestType: RequestType.post,
        body: body
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      if(showLoader){
        Utils.hideLoading();
      }
      return LostItemRequestResponse.fromJson(response);
    } catch (e) {
      if(showLoader){
        Utils.hideLoading();
      }
      final res = (e as dynamic).response;
      if (res != null) {
        return LostItemRequestResponse.fromJson(res?.data);
      }
      return LostItemRequestResponse(message: e.toString());
    }
  }

  Future<LostItemRequestResponse> sendRequestToAdmin(
      Map<String, dynamic> body,
      bool showLoader
      ) async {
    if(showLoader){
      Utils.showLoading();
    }
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.sendRequestToAdminByUser,
        requestType: RequestType.post,
        body: body
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      if(showLoader){
        Utils.hideLoading();
      }
      return LostItemRequestResponse.fromJson(response);
    } catch (e) {
      if(showLoader){
        Utils.hideLoading();
      }
      final res = (e as dynamic).response;
      if (res != null) {
        return LostItemRequestResponse.fromJson(res?.data);
      }
      return LostItemRequestResponse(message: e.toString());
    }
  }

  Future<LostItemPaymentResponse> payAmountLostItem(
      Map<String, dynamic> body,
      bool showLoader
      ) async {
    if(showLoader){
      Utils.showLoading();
    }
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.payAmountLostItem,
        requestType: RequestType.post,
        body: body
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      if(showLoader){
        Utils.hideLoading();
      }
      return LostItemPaymentResponse.fromJson(response);
    } catch (e) {
      if(showLoader){
        Utils.hideLoading();
      }
      final res = (e as dynamic).response;
      if (res != null) {
        return LostItemPaymentResponse.fromJson(res?.data);
      }
      return LostItemPaymentResponse(message: e.toString());
    }
  }

  Future<CommonResponse> bookingLostItemConfirmation(Map<String, dynamic> body) async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.webHookFrontEndLostItem,
      requestType: RequestType.post,
      body: body,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return CommonResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return CommonResponse.fromJson(res?.data);
      }
      return CommonResponse(message: e.toString());
    }
  }

  Future<PromoCodeResponse> applyCoupon(Map<String, dynamic> body) async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.applyCouponCode,
      requestType: RequestType.post,
      body: body,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return PromoCodeResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return PromoCodeResponse.fromJson(res?.data);
      }
      return PromoCodeResponse(message: e.toString());
    }
  }

  Future<CommonResponse> forgotPassword(Map<String, dynamic> body) async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.forgotPassword,
      requestType: RequestType.post,
      body: body,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return CommonResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return CommonResponse.fromJson(res?.data);
      }
      return CommonResponse(message: e.toString());
    }
  }

  /* Future<LoginResponse> loginApi(Map<String, dynamic> body) async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.login,
      requestType: RequestType.post,
      body: body,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return LoginResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return LoginResponse.fromJson(res?.data);
      }
      return LoginResponse(message: e.toString());
    }
  }

  Future<CommonResponse> contactUs(Map<String, dynamic> body) async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.contactus,
      requestType: RequestType.post,
      body: body,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return CommonResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return CommonResponse.fromJson(res?.data);
      }
      return CommonResponse(message: e.toString());
    }
  }

  Future<CommonResponse> createTask(Map<String, dynamic> body) async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.createTask,
      requestType: RequestType.post,
      body: body,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return CommonResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return CommonResponse.fromJson(res?.data);
      }
      return CommonResponse(message: e.toString());
    }
  }

  Future<CmsResponse> cms(int type) async {
    Utils.showLoading();
    String urlWithParams = "${ApiConstants.cms}/$type";
    ApiRequest apiRequest = ApiRequest(
      url: urlWithParams,
      requestType: RequestType.get,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return CmsResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return CmsResponse.fromJson(res?.data);
      }
      return CmsResponse(message: e.toString());
    }
  }

  Future<TaskModel> getTask() async {
    String urlWithParams = ApiConstants.getTask;
    ApiRequest apiRequest = ApiRequest(
      url: urlWithParams,
      requestType: RequestType.get,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return TaskModel.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return TaskModel.fromJson(res?.data);
      }
      return TaskModel(message: e.toString());
    }
  }

  Future<CommonResponse> changePassword(Map<String, dynamic> body) async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.changePassword,
      requestType: RequestType.put,
      body: body,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return CommonResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return CommonResponse.fromJson(res?.data);
      }
      return CommonResponse(message: e.toString());
    }
  }

  Future<CommonResponse> notificationStatus(Map<String, dynamic> body) async {
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.notificationStatus,
      requestType: RequestType.post,
      body: body,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      return CommonResponse.fromJson(response);
    } catch (e) {
      final res = (e as dynamic).response;
      if (res != null) {
        return CommonResponse.fromJson(res?.data);
      }
      return CommonResponse(message: e.toString());
    }
  }

  Future<CommonResponse> logout() async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.logout,
      requestType: RequestType.post,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return CommonResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return CommonResponse.fromJson(res?.data);
      }
      return CommonResponse(message: e.toString());
    }
  }

  Future<CommonResponse> deleteAccount() async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.deleteAccount,
      requestType: RequestType.post,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return CommonResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return CommonResponse.fromJson(res?.data);
      }
      return CommonResponse(message: e.toString());
    }
  }

  Future<EmployeesResponse> getEmployees(Map<String, dynamic> body) async {
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.getEmployees,
      requestType: RequestType.get,
      body: body,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      return EmployeesResponse.fromJson(response);
    } catch (e) {
      final res = (e as dynamic).response;
      if (res != null) {
        return EmployeesResponse.fromJson(res?.data);
      }
      return EmployeesResponse(message: e.toString());
    }
  }

  Future<EmployeesResponse> getAllEmployees(Map<String, dynamic> body) async {
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.getEmployeesGet,
      requestType: RequestType.get,
      body: body,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      return EmployeesResponse.fromJson(response);
    } catch (e) {
      final res = (e as dynamic).response;
      if (res != null) {
        return EmployeesResponse.fromJson(res?.data);
      }
      return EmployeesResponse(message: e.toString());
    }
  }

  Future<CommonResponse> createRoute(Map<String, dynamic> body) async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.createRoute,
      requestType: RequestType.post,
      body: body,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return CommonResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return CommonResponse.fromJson(res?.data);
      }
      return CommonResponse(message: e.toString());
    }
  }

  Future<GeneratePdfResponse> report(Map<String, dynamic> body) async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.report,
      requestType: RequestType.post,
      body: body,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return GeneratePdfResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return GeneratePdfResponse.fromJson(res?.data);
      }
      return GeneratePdfResponse(message: e.toString());
    }
  }

  Future<HomeResponse> home() async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.home,
      requestType: RequestType.get,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return HomeResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return HomeResponse.fromJson(res?.data);
      }
      return HomeResponse(message: e.toString());
    }
  }

  Future<EmployeeListResponse> getEmployeeList() async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.employeeList,
      requestType: RequestType.get,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return EmployeeListResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return EmployeeListResponse.fromJson(res?.data);
      }
      return EmployeeListResponse(message: e.toString());
    }
  }

  Future<ProfileResponse> getProfile() async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.getProfile,
      requestType: RequestType.get,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return ProfileResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return ProfileResponse.fromJson(res?.data);
      }
      return ProfileResponse(message: e.toString());
    }
  }

  Future<NotificationResponse> getNotification() async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.notificationList,
      requestType: RequestType.get,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return NotificationResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return NotificationResponse.fromJson(res?.data);
      }
      return NotificationResponse(message: e.toString());
    }
  }

  Future<StopResponse> getScheduleDetail(String id) async {
    Utils.showLoading();
    String urlWithParams = "${ApiConstants.scheduleDetail}/$id";
    ApiRequest apiRequest = ApiRequest(
      url: urlWithParams,
      requestType: RequestType.get,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return StopResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return StopResponse.fromJson(res?.data);
      }
      return StopResponse(message: e.toString());
    }
  }

  Future<CurrentPastResponse> getCurrentPast(Map<String, dynamic> body) async {
    Utils.showLoading();
    String queryString = Uri(queryParameters: body).query;
    String urlWithParams = "${ApiConstants.currentPast}?$queryString";
    ApiRequest apiRequest = ApiRequest(
      url: urlWithParams,
      requestType: RequestType.get,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return CurrentPastResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return CurrentPastResponse.fromJson(res?.data);
      }
      return CurrentPastResponse(message: e.toString());
    }
  }

  Future<StopDetailResponse> getStopDetail(String id) async {
    Utils.showLoading();
    String urlWithParams = "${ApiConstants.stopDetail}/$id";
    ApiRequest apiRequest = ApiRequest(
      url: urlWithParams,
      requestType: RequestType.get,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return StopDetailResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return StopDetailResponse.fromJson(res?.data);
      }
      return StopDetailResponse(message: e.toString());
    }
  }

  Future<LoginResponse> updateProfile(
    Map<String, dynamic> body,
    String imagePath,
  ) async {
    Utils.showLoading();
    if (imagePath.isNotEmpty && !(imagePath.startsWith("http"))) {
      Logger().d("djhfdjfdsfd");
      body['image'] = await getMultipart(path: imagePath);
    }
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.editProfile,
      requestType: RequestType.put,
      body: body,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return LoginResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return LoginResponse.fromJson(res?.data);
      }
      return LoginResponse(message: e.toString());
    }
  }

  Future<GeneratePdfResponse> generatePdf(String id) async {
    Utils.showLoading();
    String urlWithParams = "${ApiConstants.generatePdf}/$id";
    ApiRequest apiRequest = ApiRequest(
      url: urlWithParams,
      requestType: RequestType.get,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return GeneratePdfResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return GeneratePdfResponse.fromJson(res?.data);
      }
      return GeneratePdfResponse(message: e.toString());
    }
  }

  Future<FaqResponse> faq() async {
    Utils.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.faq,
      requestType: RequestType.get,
    );
    try {
      var response = await _baseClient.handleRequest(apiRequest);
      Utils.hideLoading();
      return FaqResponse.fromJson(response);
    } catch (e) {
      Utils.hideLoading();
      final res = (e as dynamic).response;
      if (res != null) {
        return FaqResponse.fromJson(res?.data);
      }
      return FaqResponse(message: e.toString());
    }
  }*/

  static Future<dio.MultipartFile> getMultipart({required String path}) async {
    String fileName = path.split('/').last;
    String? mimeType = mime(fileName);
    String? mimee = mimeType?.split('/')[0];
    String? type = mimeType?.split('/')[1];
    return await dio.MultipartFile.fromFile(
      path,
      filename: fileName,
      contentType: MediaType(mimee ?? 'image', type ?? 'jpeg'),
    );
  }
}
