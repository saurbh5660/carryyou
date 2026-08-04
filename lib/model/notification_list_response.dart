class NotificationListResponse {
  NotificationListResponse({
      this.success, 
      this.code, 
      this.message, 
      this.body,});

  NotificationListResponse.fromJson(dynamic json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['body'] != null) {
      body = [];
      json['body'].forEach((v) {
        body?.add(NotificationBody.fromJson(v));
      });
    }
  }
  bool? success;
  int? code;
  String? message;
  List<NotificationBody>? body;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['code'] = code;
    map['message'] = message;
    if (body != null) {
      map['body'] = body?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class NotificationBody {
  NotificationBody({
      this.id, 
      this.createdAt, 
      this.updatedAt, 
      this.senderId, 
      this.recevierId, 
      this.isRead, 
      this.title, 
      this.message, 
      this.type, 
      this.user,});

  NotificationBody.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    senderId = json['senderId'];
    recevierId = json['recevierId'];
    isRead = json['isRead'];
    title = json['title'];
    message = json['message'];
    type = json['type'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  String? id;
  String? createdAt;
  String? updatedAt;
  String? senderId;
  String? recevierId;
  int? isRead;
  String? title;
  String? message;
  int? type;
  User? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['senderId'] = senderId;
    map['recevierId'] = recevierId;
    map['isRead'] = isRead;
    map['title'] = title;
    map['message'] = message;
    map['type'] = type;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }

}

class User {
  User({
      this.id, 
      this.createdAt, 
      this.updatedAt, 
      this.role, 
      this.notificationStatus, 
      this.walletAmount, 
      this.stripeAccountId, 
      this.hasAccountId, 
      this.adminApprovalStatus, 
      this.isNotificationOnOff, 
      this.fullName, 
      this.email, 
      this.countryCode, 
      this.phoneNumber, 
      this.profilePicture, 
      this.city, 
      this.country, 
      this.socialType, 
      this.socialId, 
      this.customerId, 
      this.status, 
      this.isOtpVerified, 
      this.location, 
      this.latitude, 
      this.longitude, 
      this.isOnline, 
      this.driversLicenseNumber, 
      this.issuedOn, 
      this.licenceType, 
      this.dob, 
      this.nationality, 
      this.vehicleNumber, 
      this.vehicleModel, 
      this.vehicleColor, 
      this.petsAllowed, 
      this.sixPlusSeats,});

  User.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    role = json['role'];
    notificationStatus = json['notificationStatus'];
    walletAmount = json['walletAmount'];
    stripeAccountId = json['stripeAccountId'];
    hasAccountId = json['hasAccountId'];
    adminApprovalStatus = json['adminApprovalStatus'];
    isNotificationOnOff = json['isNotificationOnOff'];
    fullName = json['fullName'];
    email = json['email'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    profilePicture = json['profilePicture'];
    city = json['city'];
    country = json['country'];
    socialType = json['socialType'];
    socialId = json['socialId'];
    customerId = json['customerId'];
    status = json['status'];
    isOtpVerified = json['isOtpVerified'];
    location = json['location'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isOnline = json['isOnline'];
    driversLicenseNumber = json['driversLicenseNumber'];
    issuedOn = json['issuedOn'];
    licenceType = json['licenceType'];
    dob = json['dob'];
    nationality = json['nationality'];
    vehicleNumber = json['vehicleNumber'];
    vehicleModel = json['vehicleModel'];
    vehicleColor = json['vehicleColor'];
    petsAllowed = json['petsAllowed'];
    sixPlusSeats = json['sixPlusSeats'];
  }
  String? id;
  String? createdAt;
  String? updatedAt;
  int? role;
  int? notificationStatus;
  String? walletAmount;
  dynamic stripeAccountId;
  int? hasAccountId;
  int? adminApprovalStatus;
  int? isNotificationOnOff;
  String? fullName;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? profilePicture;
  String? city;
  String? country;
  int? socialType;
  dynamic socialId;
  String? customerId;
  int? status;
  int? isOtpVerified;
  String? location;
  String? latitude;
  String? longitude;
  int? isOnline;
  String? driversLicenseNumber;
  String? issuedOn;
  String? licenceType;
  String? dob;
  String? nationality;
  String? vehicleNumber;
  String? vehicleModel;
  String? vehicleColor;
  int? petsAllowed;
  int? sixPlusSeats;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['role'] = role;
    map['notificationStatus'] = notificationStatus;
    map['walletAmount'] = walletAmount;
    map['stripeAccountId'] = stripeAccountId;
    map['hasAccountId'] = hasAccountId;
    map['adminApprovalStatus'] = adminApprovalStatus;
    map['isNotificationOnOff'] = isNotificationOnOff;
    map['fullName'] = fullName;
    map['email'] = email;
    map['countryCode'] = countryCode;
    map['phoneNumber'] = phoneNumber;
    map['profilePicture'] = profilePicture;
    map['city'] = city;
    map['country'] = country;
    map['socialType'] = socialType;
    map['socialId'] = socialId;
    map['customerId'] = customerId;
    map['status'] = status;
    map['isOtpVerified'] = isOtpVerified;
    map['location'] = location;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['isOnline'] = isOnline;
    map['driversLicenseNumber'] = driversLicenseNumber;
    map['issuedOn'] = issuedOn;
    map['licenceType'] = licenceType;
    map['dob'] = dob;
    map['nationality'] = nationality;
    map['vehicleNumber'] = vehicleNumber;
    map['vehicleModel'] = vehicleModel;
    map['vehicleColor'] = vehicleColor;
    map['petsAllowed'] = petsAllowed;
    map['sixPlusSeats'] = sixPlusSeats;
    return map;
  }

}