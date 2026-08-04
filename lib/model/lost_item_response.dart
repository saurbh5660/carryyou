class LostItem {
  LostItem({
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
      this.startNavigationStatus,});

  LostItem.fromJson(dynamic json) {
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
    return map;
  }

}