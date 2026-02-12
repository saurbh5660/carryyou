class SignupResponse {
  SignupResponse({
      this.success, 
      this.code, 
      this.message, 
      this.body,});

  SignupResponse.fromJson(dynamic json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
  }
  bool? success;
  int? code;
  String? message;
  Body? body;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['code'] = code;
    map['message'] = message;
    if (body != null) {
      map['body'] = body?.toJson();
    }
    return map;
  }

}

class Body {
  Body({
      this.id, 
      this.createdAt, 
      this.updatedAt, 
      this.role, 
      this.adminApprovalStatus, 
      this.isNotificationOnOff, 
      this.fullName, 
      this.email, 
      this.countryCode, 
      this.phoneNumber, 
      this.password, 
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
      this.licenceFrontImage, 
      this.licenceBackImage, 
      this.driversLicenseNumber, 
      this.issuedOn, 
      this.licenceType, 
      this.dob, 
      this.nationality, 
      this.expiryDate, 
      this.pictureOfVehicle, 
      this.typeOfVehicle, 
      this.vehicleRegistrationImage, 
      this.registrationExpiryDate, 
      this.insurancePolicyImage, 
      this.insuranceExpiryDate, 
      this.vehicleNumber, 
      this.resetToken, 
      this.resetTokenExpires, 
      this.deviceToken, 
      this.deviceType, 
      this.socketId, 
      this.token,});

  Body.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    role = json['role'];
    adminApprovalStatus = json['adminApprovalStatus'];
    isNotificationOnOff = json['isNotificationOnOff'];
    fullName = json['fullName'];
    email = json['email'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    password = json['password'];
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
    licenceFrontImage = json['licenceFrontImage'];
    licenceBackImage = json['licenceBackImage'];
    driversLicenseNumber = json['driversLicenseNumber'];
    issuedOn = json['issuedOn'];
    licenceType = json['licenceType'];
    dob = json['dob'];
    nationality = json['nationality'];
    expiryDate = json['expiryDate'];
    pictureOfVehicle = json['pictureOfVehicle'];
    typeOfVehicle = json['typeOfVehicle'];
    vehicleRegistrationImage = json['vehicleRegistrationImage'];
    registrationExpiryDate = json['registrationExpiryDate'];
    insurancePolicyImage = json['insurancePolicyImage'];
    insuranceExpiryDate = json['insuranceExpiryDate'];
    vehicleNumber = json['vehicleNumber'];
    resetToken = json['resetToken'];
    resetTokenExpires = json['resetTokenExpires'];
    deviceToken = json['deviceToken'];
    deviceType = json['deviceType'];
    socketId = json['socketId'];
    token = json['token'];
  }
  String? id;
  String? createdAt;
  String? updatedAt;
  int? role;
  int? adminApprovalStatus;
  int? isNotificationOnOff;
  String? fullName;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? password;
  String? profilePicture;
  String? city;
  String? country;
  int? socialType;
  dynamic socialId;
  String? customerId;
  int? status;
  int? isOtpVerified;
  dynamic location;
  dynamic latitude;
  dynamic longitude;
  int? isOnline;
  dynamic licenceFrontImage;
  dynamic licenceBackImage;
  dynamic driversLicenseNumber;
  dynamic issuedOn;
  dynamic licenceType;
  dynamic dob;
  dynamic nationality;
  dynamic expiryDate;
  dynamic pictureOfVehicle;
  int? typeOfVehicle;
  dynamic vehicleRegistrationImage;
  dynamic registrationExpiryDate;
  dynamic insurancePolicyImage;
  dynamic insuranceExpiryDate;
  dynamic vehicleNumber;
  dynamic resetToken;
  dynamic resetTokenExpires;
  String? deviceToken;
  String? deviceType;
  dynamic socketId;
  String? token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['role'] = role;
    map['adminApprovalStatus'] = adminApprovalStatus;
    map['isNotificationOnOff'] = isNotificationOnOff;
    map['fullName'] = fullName;
    map['email'] = email;
    map['countryCode'] = countryCode;
    map['phoneNumber'] = phoneNumber;
    map['password'] = password;
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
    map['licenceFrontImage'] = licenceFrontImage;
    map['licenceBackImage'] = licenceBackImage;
    map['driversLicenseNumber'] = driversLicenseNumber;
    map['issuedOn'] = issuedOn;
    map['licenceType'] = licenceType;
    map['dob'] = dob;
    map['nationality'] = nationality;
    map['expiryDate'] = expiryDate;
    map['pictureOfVehicle'] = pictureOfVehicle;
    map['typeOfVehicle'] = typeOfVehicle;
    map['vehicleRegistrationImage'] = vehicleRegistrationImage;
    map['registrationExpiryDate'] = registrationExpiryDate;
    map['insurancePolicyImage'] = insurancePolicyImage;
    map['insuranceExpiryDate'] = insuranceExpiryDate;
    map['vehicleNumber'] = vehicleNumber;
    map['resetToken'] = resetToken;
    map['resetTokenExpires'] = resetTokenExpires;
    map['deviceToken'] = deviceToken;
    map['deviceType'] = deviceType;
    map['socketId'] = socketId;
    map['token'] = token;
    return map;
  }

}