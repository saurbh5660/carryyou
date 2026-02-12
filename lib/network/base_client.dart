import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:get/route_manager.dart';
import '../common/apputills.dart';
import '../common/db_helper.dart';
import '../routes/app_routes.dart';
import 'no_internet_page.dart';

enum RequestType { post, postRaw, get, delete, put, patch }

class ApiRequest {
  final String url;
  final RequestType requestType;
  final Map<String, dynamic>? body;
  final Map<String, dynamic>? headers;

  ApiRequest({
    required this.url,
    required this.requestType,
    this.body,
    this.headers,
  });
}
class BaseClient {
  static final BaseClient _singleton = BaseClient._internal();
  static late Dio _dio;

  factory BaseClient() {
    return _singleton;
  }
  BaseClient._internal();
  Future<void> init() async {
    _dio = Dio();
    _dio = getDio();
  }
  Dio getDio() {
    BaseOptions options = BaseOptions(
        receiveTimeout: const Duration(seconds: 30),
        connectTimeout: const Duration(seconds: 30));
    _dio.options = options;
    _dio.options.followRedirects = false;
    _dio.options.headers["Content-Type"] = "application/json";
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient(
        context: SecurityContext(withTrustedRoots: false),
      );
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    _dio.interceptors.clear();
    _dio.interceptors.add(LoggingInterceptors());
    return _dio;
  }
  static Options? getHeaderToken() {
    String? token = DbHelper().getUserToken();
    if (token != null) {
      debugPrint("User Token => $token");
      var headerOptions = Options(headers: {
        'authorization': "Bearer $token",
        "SECRETKEY": "U2FsdGVkX1/v8OtrRYp4kjiK8iymYg7ojJYdNZEUJko=",
        "PUBLISHKEY": "U2FsdGVkX1/+cTKRx/ZLdvat9TuNkFgipEnbKTIsYZk=",
      });
      return headerOptions;
    }
    return Options(headers: {
      "SECRETKEY": "U2FsdGVkX1/v8OtrRYp4kjiK8iymYg7ojJYdNZEUJko=",
      "PUBLISHKEY": "U2FsdGVkX1/+cTKRx/ZLdvat9TuNkFgipEnbKTIsYZk=",
    });
  }
  Future<dynamic> handleRequest(ApiRequest apiRequest) async {
    bool isOnline = await hasNetwork();
    if (!isOnline) {
      Utils.showErrorToast(message: 'No Internet, Please try later !');
      Get.to(() => NoInternetPage(
            callBack: (apiRequest) {
              handleRequest(apiRequest);
            },
            apiRequest: apiRequest,
          ));
      return;
    }
    switch (apiRequest.requestType) {
      case RequestType.post:
        var response = await _dio.post(apiRequest.url,
            data: FormData.fromMap(apiRequest.body ?? {}),
            options: getHeaderToken());
        return response.data;

      case RequestType.postRaw:
        var response = await _dio.post(apiRequest.url,
            data: apiRequest.body,
            options: getHeaderToken());
        return response.data;

      case RequestType.get:
        var response =
            await _dio.get(apiRequest.url, options: getHeaderToken());
        return response.data;

      case RequestType.delete:
        var response = await _dio.delete(apiRequest.url,
            data: FormData.fromMap(apiRequest.body ?? {}),
            options: getHeaderToken());
        return response.data;

      case RequestType.patch:
        var response = await _dio.patch(apiRequest.url,
            data: FormData.fromMap(apiRequest.body ?? {}),
            options: getHeaderToken());
        return response.data;

      case RequestType.put:
        var response = await _dio.put(apiRequest.url,
            data: FormData.fromMap(apiRequest.body ?? {}),
            options: getHeaderToken());
        return response.data;
    }
  }
  Future<dynamic> handleMultipartRequest(
      ApiRequest apiRequest, String imageFile) async {
    bool isOnline = await hasNetwork();
    if (!isOnline) {
      Utils.showErrorToast(message: 'No Internet, Please try later !');
      Get.to(() => NoInternetPage(
            callBack: (apiRequest) {
              handleMultipartRequest(apiRequest, imageFile);
            },
            apiRequest: apiRequest,
          ));

      return;
    }
    FormData data = FormData.fromMap({
      "image": await MultipartFile.fromFile(imageFile),
    });
    var res =
        await _dio.post(apiRequest.url, data: data, options: getHeaderToken());
    if (kDebugMode) {
      print(res.data.toString());
    }
    return res.data;
  }

  static Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
/// loggingInterceptors
class LoggingInterceptors extends Interceptor {
  String printObject(Object object) {
    // Encode your object and then decode your object to Map variable
    Map jsonMapped = json.decode(json.encode(object));

    // Using JsonEncoder for spacing
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');

    // encode it to string
    String prettyPrint = encoder.convert(jsonMapped);
    return prettyPrint;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint(
        "--> ${options.method.toUpperCase()} ${"${options.baseUrl}${options.path}"}");
    debugPrint("Headers:");
    options.headers.forEach((k, v) => debugPrint('$k: $v'));
    options.queryParameters.forEach((k, v) => debugPrint('$k: $v'));
    if (options.data != null) {
      try {
        FormData formData = options.data as FormData;
        debugPrint("Body:");
        var buffer = [];
        for (MapEntry<String, String> pair in formData.fields) {
          buffer.add('${pair.key}:${pair.value}');
        }
        debugPrint("Body:{${buffer.join(', ')}}");
      } catch (e) {
        debugPrint("Body: ${printObject(options.data)}");
      }
    }
    debugPrint(options.method.toUpperCase());
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint(
        "${err.message} ${(err.response?.requestOptions != null ? ("${err.response?.requestOptions.baseUrl} ${err.response?.requestOptions.path}") : 'URL')}");
    debugPrint(
        "${err.response != null ? err.response!.data : 'Unknown Error'}");
    debugPrint("End error");

    if (err.type == DioExceptionType.connectionError) {
      Utils.hideLoading();
      Utils.showErrorToast(message: "Something went wrong connection Error");
      return;
    }
    if (err.type == DioExceptionType.receiveTimeout) {
      Utils.hideLoading();
      Utils.showErrorToast(message: "Something went wrong receive Timeout");
      return;
    }

    if (err.response?.statusCode == 401) {
      Utils.hideLoading();
      DbHelper().clearAll();
      Get.offAllNamed(AppRoutes.loginView);
      Utils.showErrorToast(message: "Session Expired!");
      return;
    }

    return super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        "${response.statusCode} ${(response.requestOptions.baseUrl + response.requestOptions.path)}");
    debugPrint("Headers:");
    response.headers.forEach((k, v) => debugPrint('$k: $v'));
    printPrettyJson(response.data);
    return super.onResponse(response, handler);
  }
}
