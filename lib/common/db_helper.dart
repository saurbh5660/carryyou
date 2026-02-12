import 'dart:convert';
import 'package:get_storage/get_storage.dart';

import '../model/signup_response.dart';

class DbHelper {
  static final DbHelper _singleton = DbHelper._internal();
  static late GetStorage getStorage;

  static const String _userModel = "userModel";
  static const String _fcmToken = "fcmToken";
  static const String _userType = "userType";
  static const String _userId = "userId";
  static const String _userToken = "userToken";
  static const String _isLoggedIn = "isLoggedIn";
  static const String _isSocial = "isSocial";
  static const String _loginTime = "loginTime";
  static const String _connectTime = "connectTime";
  static const String _theme = "theme";

  static const JsonDecoder _decoder = JsonDecoder();
  static const JsonEncoder _encoder = JsonEncoder.withIndent('  ');

  static const String _rememberMe = "rememberMe";
  static const String _savedEmail = "savedEmail";
  static const String _savedPassword = "savedPassword";

  factory DbHelper() {
    return _singleton;
  }

  DbHelper._internal() {
    getStorage = GetStorage();
    _init();
  }

  Future<void> _init() async {
    await GetStorage.init();
    getStorage = GetStorage();
  }

  Future<void> _savePref(String key, Object? value) async {
    var prefs = getStorage;
    if (prefs.hasData(key)) {
      prefs.remove(key);
    }
    if (value is bool) {
      return prefs.write(key, value);
    } else if (value is int) {
      return prefs.write(key, value);
    } else if (value is String) {
      return prefs.write(key, value);
    } else if (value is double) {
      return prefs.write(key, value);
    }
  }

  T _getPref<T>(String key) {
    return getStorage.read(key) as T;
  }

  void clearAll() {
    getStorage.erase();
  }

  bool getRememberMe() {
    return _getPref(_rememberMe) ?? false;
  }

  void saveRememberMe(bool value) {
    _savePref(_rememberMe, value);
  }

  String? getSavedEmail() {
    return _getPref(_savedEmail);
  }

  void saveSavedEmail(String? email) {
    _savePref(_savedEmail, email);
  }

  String? getSavedPassword() {
    return _getPref(_savedPassword);
  }

  void saveSavedPassword(String? password) {
    _savePref(_savedPassword, password);
  }

  void clearWithTheme() {
    List<String> allKeys = List.from(getStorage.getKeys());
    for (String key in allKeys) {
      if (!_theme.contains(key)) {
        print("object key $key");
        getStorage.remove(key);
      }
    }
  }

  String getFcmToken() {
    return _getPref(_fcmToken);
  }

  void saveFcmToken(String? token) {
    _savePref(_fcmToken, token);
  }

  String getTheme() {
    return _getPref(_theme) ?? "light";
  }

  void saveTheme(String theme) {
    _savePref(_theme, theme);
  }

  /// UserType
  /// 0 - Personal,
  /// 1 - Church,
  /// 2 - Business,
  /// 3 - Non-Profile,
  int getUserType() {
    return _getPref(_userType) ;
  }

  /// UserType
  /// 0 - Personal,
  /// 1 - Church,
  /// 2 - Business,
  /// 3 - Non-Profile,
  void saveUserType(int id) {
    _savePref(_userType, id);
  }

  String? getUserId() {
    return _getPref(_userId);
  }

  void saveUserId(String? userId) {
    _savePref(_userId, userId);
  }

  String? getUserToken() {
    return _getPref(_userToken);
  }

  void saveUserToken(String? token) {
    _savePref(_userToken, token);
  }

  Body? getUserModel() {
    String? user = _getPref(_userModel);
    if (user != null) {
      Map<String, dynamic> userMap = _decoder.convert(user);
      return Body.fromJson(userMap);
    } else {
      return null;
    }
  }

  void saveUserModel(Body? userModel) {
    if (userModel != null) {
      String value = _encoder.convert(userModel);
      _savePref(_userModel, value);
    } else {
      _savePref(_userModel, null);
    }
  }

  bool getIsLoggedIn() {
    return _getPref(_isLoggedIn) ?? false;
  }

  void saveIsLoggedIn(bool value) {
    _savePref(_isLoggedIn, value);
  }

  bool? getLoggedFirst() {
    return _getPref(_loginTime) ?? false;
  }

  void saveLoggedFirst(bool value) {
    _savePref(_loginTime, value);
  }

  bool? getConnectionFirst() {
    return _getPref(_connectTime) ?? false;
  }

  void saveConnectionFirst(bool value) {
    _savePref(_connectTime, value);
  }

  bool getIsSocial() {
    return _getPref(_isSocial) ?? false;
  }

  void saveIsSocial(bool value) {
    _savePref(_isSocial, value);
  }


/*
  NotificationEntity? convertStringToNotificationEntity(String? value) {
    if (value == null) {
      return null;
    }
    Map<String, dynamic> map = _decoder.convert(value);
    return NotificationEntity.fromJson(map);
  }

  String convertNotificationEntityToString(
      NotificationEntity? notificationEntity) {
    String value = _encoder.convert(notificationEntity);
    return value;
  }
*/

}
