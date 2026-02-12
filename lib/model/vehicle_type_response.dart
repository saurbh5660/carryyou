class VehicleTypeResponse {
  VehicleTypeResponse({
      this.success, 
      this.code, 
      this.message,
      this.body,});

  VehicleTypeResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    code = json['code'];
    if (json['body'] != null) {
      body = [];
      json['body'].forEach((v) {
        body?.add(VehiclePriceBody.fromJson(v));
      });
    }
  }
  bool? success;
  int? code;
  String? message;
  List<VehiclePriceBody>? body;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    map['code'] = code;
    if (body != null) {
      map['body'] = body?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class VehiclePriceBody {
  VehiclePriceBody({
      this.id, 
      this.name, 
      this.image, 
      this.estimatedFare, 
      this.distanceKm, 
      this.durationMinutes,});

  VehiclePriceBody.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    estimatedFare = json['estimatedFare'];
    distanceKm = json['distanceKm'];
    durationMinutes = json['durationMinutes'];
  }
  String? id;
  String? name;
  String? image;
  double? estimatedFare;
  double? distanceKm;
  int? durationMinutes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    map['estimatedFare'] = estimatedFare;
    map['distanceKm'] = distanceKm;
    map['durationMinutes'] = durationMinutes;
    return map;
  }

}