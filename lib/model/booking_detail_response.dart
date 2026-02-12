class BookingDetailResponse {
  BookingDetailResponse({
      this.success, 
      this.code, 
      this.message, 
      this.body,});

  BookingDetailResponse.fromJson(dynamic json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null ? BookingDetailBody.fromJson(json['body']) : null;
  }
  bool? success;
  num? code;
  String? message;
  BookingDetailBody? body;

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

class BookingDetailBody {
  BookingDetailBody({
      this.id, 
      this.createdAt, 
      this.updatedAt, 
      this.userId, 
      this.driverId, 
      this.deliveryCode, 
      this.pickUpLocation, 
      this.pickUpLatitude, 
      this.pickUpLongitude, 
      this.destinationLocation, 
      this.destinationLatitude, 
      this.destinationLongitude, 
      this.status, 
      this.amount, 
      this.distance, 
      this.typeOfVehicleId, 
      this.scheduleType, 
      this.bookingDate, 
      this.bookingTime, 
      this.paymentStatus, 
      this.otp, 
      this.otpVerify, 
      this.reason, 
      this.user, 
      this.driver,
      this.typeOfVechile,
  });

  BookingDetailBody.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
    driverId = json['driverId'];
    deliveryCode = json['deliveryCode'];
    pickUpLocation = json['pickUpLocation'];
    pickUpLatitude = json['pickUpLatitude'];
    pickUpLongitude = json['pickUpLongitude'];
    destinationLocation = json['destinationLocation'];
    destinationLatitude = json['destinationLatitude'];
    destinationLongitude = json['destinationLongitude'];
    status = json['status'];
    amount = json['amount'];
    distance = json['distance'];
    typeOfVehicleId = json['typeOfVehicleId'];
    scheduleType = json['scheduleType'];
    bookingDate = json['bookingDate'];
    bookingTime = json['bookingTime'];
    paymentStatus = json['paymentStatus'];
    otp = json['otp'];
    otpVerify = json['otpVerify'];
    reason = json['reason'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    driver = json['driver'] != null ? User.fromJson(json['driver']) : null;
    typeOfVechile = json['typeOfVechile'] != null ? TypeOfVechile.fromJson(json['typeOfVechile']) : null;
  }
  String? id;
  String? createdAt;
  String? updatedAt;
  String? userId;
  dynamic driverId;
  dynamic deliveryCode;
  String? pickUpLocation;
  String? pickUpLatitude;
  String? pickUpLongitude;
  String? destinationLocation;
  String? destinationLatitude;
  String? destinationLongitude;
  num? status;
  num? amount;
  num? distance;
  String? typeOfVehicleId;
  num? scheduleType;
  dynamic bookingDate;
  dynamic bookingTime;
  num? paymentStatus;
  String? otp;
  num? otpVerify;
  dynamic reason;
  User? user;
  TypeOfVechile? typeOfVechile;
  User? driver;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['userId'] = userId;
    map['driverId'] = driverId;
    map['deliveryCode'] = deliveryCode;
    map['pickUpLocation'] = pickUpLocation;
    map['pickUpLatitude'] = pickUpLatitude;
    map['pickUpLongitude'] = pickUpLongitude;
    map['destinationLocation'] = destinationLocation;
    map['destinationLatitude'] = destinationLatitude;
    map['destinationLongitude'] = destinationLongitude;
    map['status'] = status;
    map['amount'] = amount;
    map['distance'] = distance;
    map['typeOfVehicleId'] = typeOfVehicleId;
    map['scheduleType'] = scheduleType;
    map['bookingDate'] = bookingDate;
    map['bookingTime'] = bookingTime;
    map['paymentStatus'] = paymentStatus;
    map['otp'] = otp;
    map['otpVerify'] = otpVerify;
    map['reason'] = reason;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    if (driver != null) {
      map['driver'] = driver?.toJson();
    }
    if (typeOfVechile != null) {
      map['typeOfVechile'] = typeOfVechile?.toJson();
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
      this.avgRating,
  });

  User.fromJson(dynamic json) {
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
    avgRating = json['avgRating'];
  }
  String? id;
  String? createdAt;
  String? updatedAt;
  num? role;
  num? adminApprovalStatus;
  num? isNotificationOnOff;
  String? fullName;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? password;
  String? profilePicture;
  String? city;
  String? country;
  num? socialType;
  dynamic socialId;
  String? customerId;
  num? status;
  num? isOtpVerified;
  String? location;
  String? latitude;
  String? longitude;
  num? isOnline;
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
  num? avgRating;


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
    map['avgRating'] = avgRating;
    return map;
  }

}

class TypeOfVechile {
  TypeOfVechile({
    this.id,
    this.name,
    this.image,
  });

  TypeOfVechile.fromJson(dynamic json) {
    name = json['name'];
    image = json['image'];
    id = json['id'];
  }
  String? id;
  String? image;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    return map;
  }

}