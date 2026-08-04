class LostItemRequestResponse {
  LostItemRequestResponse({
      this.success, 
      this.code, 
      this.message, 
      this.body,});

  LostItemRequestResponse.fromJson(dynamic json) {
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
      this.createdAt, 
      this.updatedAt, 
      this.id, 
      this.userConfirm, 
      this.driverConfirm, 
      this.sendToAdminOrNot, 
      this.paymentStatus, 
      this.dropLatitude, 
      this.dropLongitude, 
      this.dropLocation, 
      this.amount, 
      this.startNavigationStatus, 
      this.bookingId, 
      this.userId, 
      this.driverId, 
      this.description, 
      this.countryCode, 
      this.phoneNumber,});

  Body.fromJson(dynamic json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    userConfirm = json['userConfirm'];
    driverConfirm = json['driverConfirm'];
    sendToAdminOrNot = json['sendToAdminOrNot'];
    paymentStatus = json['paymentStatus'];
    dropLatitude = json['dropLatitude'];
    dropLongitude = json['dropLongitude'];
    dropLocation = json['dropLocation'];
    amount = json['amount'];
    startNavigationStatus = json['startNavigationStatus'];
    bookingId = json['bookingId'];
    userId = json['userId'];
    driverId = json['driverId'];
    description = json['description'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
  }
  String? createdAt;
  String? updatedAt;
  String? id;
  int? userConfirm;
  int? driverConfirm;
  int? sendToAdminOrNot;
  int? paymentStatus;
  dynamic dropLatitude;
  dynamic dropLongitude;
  dynamic dropLocation;
  dynamic amount;
  int? startNavigationStatus;
  String? bookingId;
  String? userId;
  String? driverId;
  String? description;
  String? countryCode;
  String? phoneNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['id'] = id;
    map['userConfirm'] = userConfirm;
    map['driverConfirm'] = driverConfirm;
    map['sendToAdminOrNot'] = sendToAdminOrNot;
    map['paymentStatus'] = paymentStatus;
    map['dropLatitude'] = dropLatitude;
    map['dropLongitude'] = dropLongitude;
    map['dropLocation'] = dropLocation;
    map['amount'] = amount;
    map['startNavigationStatus'] = startNavigationStatus;
    map['bookingId'] = bookingId;
    map['userId'] = userId;
    map['driverId'] = driverId;
    map['description'] = description;
    map['countryCode'] = countryCode;
    map['phoneNumber'] = phoneNumber;
    return map;
  }

}