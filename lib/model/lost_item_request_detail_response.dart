class LostItemRequestDetailResponse {
  LostItemRequestDetailResponse({
      this.success, 
      this.code, 
      this.message, 
      this.body,});

  LostItemRequestDetailResponse.fromJson(dynamic json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null ? LostItemRequestDetail.fromJson(json['body']) : null;
  }
  bool? success;
  int? code;
  String? message;
  LostItemRequestDetail? body;

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

class LostItemRequestDetail {
  LostItemRequestDetail({
      this.id, 
      this.createdAt, 
      this.updatedAt, 
      this.bookingId, 
      this.userId, 
      this.driverId, 
      this.description, 
      this.countryCode, 
      this.phoneNumber, 
      this.userConfirm, 
      this.driverConfirm, 
      this.sendToAdminOrNot, 
      this.paymentStatus, 
      this.dropLatitude, 
      this.dropLongitude, 
      this.dropLocation, 
      this.amount, 
      this.startNavigationStatus, 
      this.user, 
      this.driver, 
      this.booking,});

  LostItemRequestDetail.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    bookingId = json['bookingId'];
    userId = json['userId'];
    driverId = json['driverId'];
    description = json['description'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    userConfirm = json['userConfirm'];
    driverConfirm = json['driverConfirm'];
    sendToAdminOrNot = json['sendToAdminOrNot'];
    paymentStatus = json['paymentStatus'];
    dropLatitude = json['dropLatitude'];
    dropLongitude = json['dropLongitude'];
    dropLocation = json['dropLocation'];
    amount = json['amount'];
    startNavigationStatus = json['startNavigationStatus'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    driver = json['driver'] != null ? Driver.fromJson(json['driver']) : null;
    booking = json['booking'] != null ? Booking.fromJson(json['booking']) : null;
  }
  String? id;
  String? createdAt;
  String? updatedAt;
  String? bookingId;
  String? userId;
  String? driverId;
  String? description;
  String? countryCode;
  String? phoneNumber;
  int? userConfirm;
  int? driverConfirm;
  int? sendToAdminOrNot;
  int? paymentStatus;
  dynamic dropLatitude;
  dynamic dropLongitude;
  dynamic dropLocation;
  dynamic amount;
  int? startNavigationStatus;
  User? user;
  Driver? driver;
  Booking? booking;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['bookingId'] = bookingId;
    map['userId'] = userId;
    map['driverId'] = driverId;
    map['description'] = description;
    map['countryCode'] = countryCode;
    map['phoneNumber'] = phoneNumber;
    map['userConfirm'] = userConfirm;
    map['driverConfirm'] = driverConfirm;
    map['sendToAdminOrNot'] = sendToAdminOrNot;
    map['paymentStatus'] = paymentStatus;
    map['dropLatitude'] = dropLatitude;
    map['dropLongitude'] = dropLongitude;
    map['dropLocation'] = dropLocation;
    map['amount'] = amount;
    map['startNavigationStatus'] = startNavigationStatus;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    if (driver != null) {
      map['driver'] = driver?.toJson();
    }
    if (booking != null) {
      map['booking'] = booking?.toJson();
    }
    return map;
  }

}

class Booking {
  Booking({
      this.id, 
      this.createdAt, 
      this.updatedAt, 
      this.userId, 
      this.driverId, 
      this.pickUpLocation, 
      this.pickUpLatitude, 
      this.pickUpLongitude, 
      this.destinationLocation, 
      this.destinationLatitude, 
      this.destinationLongitude, 
      this.status, 
      this.amount, 
      this.distance, 
      this.scheduleType, 
      this.paymentStatus, 
      this.otp, 
      this.otpVerify,});

  Booking.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
    driverId = json['driverId'];
    pickUpLocation = json['pickUpLocation'];
    pickUpLatitude = json['pickUpLatitude'];
    pickUpLongitude = json['pickUpLongitude'];
    destinationLocation = json['destinationLocation'];
    destinationLatitude = json['destinationLatitude'];
    destinationLongitude = json['destinationLongitude'];
    status = json['status'];
    amount = json['amount'];
    distance = json['distance'];
    scheduleType = json['scheduleType'];
    paymentStatus = json['paymentStatus'];
    otp = json['otp'];
    otpVerify = json['otpVerify'];
  }
  String? id;
  String? createdAt;
  String? updatedAt;
  String? userId;
  String? driverId;
  String? pickUpLocation;
  String? pickUpLatitude;
  String? pickUpLongitude;
  String? destinationLocation;
  String? destinationLatitude;
  String? destinationLongitude;
  int? status;
  double? amount;
  double? distance;
  int? scheduleType;
  int? paymentStatus;
  String? otp;
  int? otpVerify;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['userId'] = userId;
    map['driverId'] = driverId;
    map['pickUpLocation'] = pickUpLocation;
    map['pickUpLatitude'] = pickUpLatitude;
    map['pickUpLongitude'] = pickUpLongitude;
    map['destinationLocation'] = destinationLocation;
    map['destinationLatitude'] = destinationLatitude;
    map['destinationLongitude'] = destinationLongitude;
    map['status'] = status;
    map['amount'] = amount;
    map['distance'] = distance;
    map['scheduleType'] = scheduleType;
    map['paymentStatus'] = paymentStatus;
    map['otp'] = otp;
    map['otpVerify'] = otpVerify;
    return map;
  }

}

class Driver {
  Driver({
      this.id, 
      this.createdAt, 
      this.updatedAt, 
      this.role, 
      this.walletAmount, 
      this.adminApprovalStatus, 
      this.isNotificationOnOff, 
      this.fullName, 
      this.email, 
      this.countryCode, 
      this.phoneNumber, 
      this.profilePicture, 
      this.city, 
      this.country, 
      this.location, 
      this.latitude, 
      this.longitude, 
      this.isOnline, 
      this.driversLicenseNumber, 
      this.issuedOn, 
      this.licenceType, 
      this.dob, 
      this.nationality, 
      this.expiryDate, 
      this.pictureOfVehicle, 
      this.vehicleRegistrationImage, 
      this.registrationExpiryDate, 
      this.insurancePolicyImage, 
      this.insuranceExpiryDate, 
      this.vehicleNumber, 
      this.deviceToken, 
      this.deviceType, 
      this.socketId,});

  Driver.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    role = json['role'];
    walletAmount = json['walletAmount'];
    adminApprovalStatus = json['adminApprovalStatus'];
    isNotificationOnOff = json['isNotificationOnOff'];
    fullName = json['fullName'];
    email = json['email'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    profilePicture = json['profilePicture'];
    city = json['city'];
    country = json['country'];
    location = json['location'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isOnline = json['isOnline'];
    driversLicenseNumber = json['driversLicenseNumber'];
    issuedOn = json['issuedOn'];
    licenceType = json['licenceType'];
    dob = json['dob'];
    nationality = json['nationality'];
    expiryDate = json['expiryDate'];
    pictureOfVehicle = json['pictureOfVehicle'];
    vehicleRegistrationImage = json['vehicleRegistrationImage'];
    registrationExpiryDate = json['registrationExpiryDate'];
    insurancePolicyImage = json['insurancePolicyImage'];
    insuranceExpiryDate = json['insuranceExpiryDate'];
    vehicleNumber = json['vehicleNumber'];
    deviceToken = json['deviceToken'];
    deviceType = json['deviceType'];
    socketId = json['socketId'];
  }
  String? id;
  String? createdAt;
  String? updatedAt;
  int? role;
  String? walletAmount;
  int? adminApprovalStatus;
  int? isNotificationOnOff;
  String? fullName;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? profilePicture;
  String? city;
  String? country;
  String? location;
  String? latitude;
  String? longitude;
  int? isOnline;
  String? driversLicenseNumber;
  String? issuedOn;
  String? licenceType;
  String? dob;
  String? nationality;
  String? expiryDate;
  String? pictureOfVehicle;
  String? vehicleRegistrationImage;
  String? registrationExpiryDate;
  String? insurancePolicyImage;
  String? insuranceExpiryDate;
  String? vehicleNumber;
  String? deviceToken;
  String? deviceType;
  String? socketId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['role'] = role;
    map['walletAmount'] = walletAmount;
    map['adminApprovalStatus'] = adminApprovalStatus;
    map['isNotificationOnOff'] = isNotificationOnOff;
    map['fullName'] = fullName;
    map['email'] = email;
    map['countryCode'] = countryCode;
    map['phoneNumber'] = phoneNumber;
    map['profilePicture'] = profilePicture;
    map['city'] = city;
    map['country'] = country;
    map['location'] = location;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['isOnline'] = isOnline;
    map['driversLicenseNumber'] = driversLicenseNumber;
    map['issuedOn'] = issuedOn;
    map['licenceType'] = licenceType;
    map['dob'] = dob;
    map['nationality'] = nationality;
    map['expiryDate'] = expiryDate;
    map['pictureOfVehicle'] = pictureOfVehicle;
    map['vehicleRegistrationImage'] = vehicleRegistrationImage;
    map['registrationExpiryDate'] = registrationExpiryDate;
    map['insurancePolicyImage'] = insurancePolicyImage;
    map['insuranceExpiryDate'] = insuranceExpiryDate;
    map['vehicleNumber'] = vehicleNumber;
    map['deviceToken'] = deviceToken;
    map['deviceType'] = deviceType;
    map['socketId'] = socketId;
    return map;
  }

}

class User {
  User({
      this.id, 
      this.createdAt, 
      this.updatedAt, 
      this.role, 
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
      this.deviceToken, 
      this.deviceType, 
      this.socketId,});

  User.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    role = json['role'];
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
    deviceToken = json['deviceToken'];
    deviceType = json['deviceType'];
    socketId = json['socketId'];
  }
  String? id;
  String? createdAt;
  String? updatedAt;
  int? role;
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
  String? deviceToken;
  String? deviceType;
  String? socketId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['role'] = role;
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
    map['deviceToken'] = deviceToken;
    map['deviceType'] = deviceType;
    map['socketId'] = socketId;
    return map;
  }

}