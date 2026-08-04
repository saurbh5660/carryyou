class BookingListResponse {
  BookingListResponse({
      this.success, 
      this.code, 
      this.message, 
      this.body,});

  BookingListResponse.fromJson(dynamic json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['body'] != null) {
      body = [];
      json['body'].forEach((v) {
        body?.add(Body.fromJson(v));
      });
    }
  }
  bool? success;
  int? code;
  String? message;
  List<Body>? body;

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

class Body {
  Body({
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
      this.driver,});

  Body.fromJson(dynamic json) {
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
    driver = json['driver'];
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
  int? status;
  double? amount;
  double? distance;
  String? typeOfVehicleId;
  int? scheduleType;
  dynamic bookingDate;
  dynamic bookingTime;
  int? paymentStatus;
  String? otp;
  int? otpVerify;
  dynamic reason;
  dynamic driver;

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
    map['driver'] = driver;
    return map;
  }

}