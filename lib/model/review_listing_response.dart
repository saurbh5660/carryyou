class ReviewListingResponse {
  ReviewListingResponse({
      this.success, 
      this.code, 
      this.message, 
      this.body,});

  ReviewListingResponse.fromJson(dynamic json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['body'] != null) {
      body = [];
      json['body'].forEach((v) {
        body?.add(ReviewBody.fromJson(v));
      });
    }
  }
  bool? success;
  int? code;
  String? message;
  List<ReviewBody>? body;

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

class ReviewBody {
  ReviewBody({
      this.id, 
      this.createdAt, 
      this.updatedAt, 
      this.userId, 
      this.driverId, 
      this.rating, 
      this.user, 
      this.comment,
      this.driver,});

  ReviewBody.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
    driverId = json['driverId'];
    comment = json['comment'];
    rating = json['rating'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    driver = json['driver'] != null ? Driver.fromJson(json['driver']) : null;
  }
  String? id;
  String? createdAt;
  String? updatedAt;
  String? userId;
  String? driverId;
  String? rating;
  String? comment;
  User? user;
  Driver? driver;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['userId'] = userId;
    map['driverId'] = driverId;
    map['rating'] = rating;
    map['comment'] = comment;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    if (driver != null) {
      map['driver'] = driver?.toJson();
    }
    return map;
  }

}

class Driver {
  Driver({
      this.id, 
      this.createdAt, 
      this.updatedAt, 
      this.role, 
      this.isProfileComplete, 
      this.isOnRide, 
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
      this.typeOfVehicleId, 
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
      this.vehicleModel, 
      this.vehicleColor, 
      this.petsAllowed, 
      this.sixPlusSeats,});

  Driver.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    role = json['role'];
    isProfileComplete = json['isProfileComplete'];
    isOnRide = json['isOnRide'];
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
    typeOfVehicleId = json['typeOfVehicleId'];
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
    vehicleModel = json['vehicleModel'];
    vehicleColor = json['vehicleColor'];
    petsAllowed = json['petsAllowed'];
    sixPlusSeats = json['sixPlusSeats'];
  }
  String? id;
  String? createdAt;
  String? updatedAt;
  int? role;
  int? isProfileComplete;
  int? isOnRide;
  int? notificationStatus;
  String? walletAmount;
  String? stripeAccountId;
  int? hasAccountId;
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
  String? location;
  String? latitude;
  String? longitude;
  int? isOnline;
  dynamic licenceFrontImage;
  dynamic licenceBackImage;
  String? driversLicenseNumber;
  String? issuedOn;
  String? licenceType;
  String? dob;
  String? nationality;
  String? expiryDate;
  String? pictureOfVehicle;
  String? typeOfVehicleId;
  String? vehicleRegistrationImage;
  String? registrationExpiryDate;
  String? insurancePolicyImage;
  String? insuranceExpiryDate;
  String? vehicleNumber;
  dynamic resetToken;
  dynamic resetTokenExpires;
  String? deviceToken;
  String? deviceType;
  String? socketId;
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
    map['isProfileComplete'] = isProfileComplete;
    map['isOnRide'] = isOnRide;
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
    map['typeOfVehicleId'] = typeOfVehicleId;
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
    map['vehicleModel'] = vehicleModel;
    map['vehicleColor'] = vehicleColor;
    map['petsAllowed'] = petsAllowed;
    map['sixPlusSeats'] = sixPlusSeats;
    return map;
  }

}

class User {
  User({
      this.id, 
      this.createdAt, 
      this.updatedAt, 
      this.role, 
      this.isProfileComplete, 
      this.isOnRide, 
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
      this.typeOfVehicleId, 
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
      this.vehicleModel, 
      this.vehicleColor, 
      this.petsAllowed, 
      this.sixPlusSeats,});

  User.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    role = json['role'];
    isProfileComplete = json['isProfileComplete'];
    isOnRide = json['isOnRide'];
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
    typeOfVehicleId = json['typeOfVehicleId'];
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
    vehicleModel = json['vehicleModel'];
    vehicleColor = json['vehicleColor'];
    petsAllowed = json['petsAllowed'];
    sixPlusSeats = json['sixPlusSeats'];
  }
  String? id;
  String? createdAt;
  String? updatedAt;
  int? role;
  int? isProfileComplete;
  int? isOnRide;
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
  dynamic typeOfVehicleId;
  dynamic vehicleRegistrationImage;
  dynamic registrationExpiryDate;
  dynamic insurancePolicyImage;
  dynamic insuranceExpiryDate;
  dynamic vehicleNumber;
  dynamic resetToken;
  dynamic resetTokenExpires;
  String? deviceToken;
  String? deviceType;
  String? socketId;
  dynamic vehicleModel;
  dynamic vehicleColor;
  int? petsAllowed;
  int? sixPlusSeats;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['role'] = role;
    map['isProfileComplete'] = isProfileComplete;
    map['isOnRide'] = isOnRide;
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
    map['typeOfVehicleId'] = typeOfVehicleId;
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
    map['vehicleModel'] = vehicleModel;
    map['vehicleColor'] = vehicleColor;
    map['petsAllowed'] = petsAllowed;
    map['sixPlusSeats'] = sixPlusSeats;
    return map;
  }

}