class CouponCodeResponse {
  CouponCodeResponse({
      this.success, 
      this.code, 
      this.message, 
      this.body,});

  CouponCodeResponse.fromJson(dynamic json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['body'] != null) {
      body = [];
      json['body'].forEach((v) {
        body?.add(CouponBody.fromJson(v));
      });
    }
  }
  bool? success;
  int? code;
  String? message;
  List<CouponBody>? body;

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

class CouponBody {
  CouponBody({
      this.id, 
      this.createdAt, 
      this.updatedAt, 
      this.name, 
      this.code, 
      this.percentageOff, 
      this.isDelete,});

  CouponBody.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    name = json['name'];
    code = json['code'];
    percentageOff = json['percentageOff'];
    isDelete = json['isDelete'];
  }
  String? id;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? code;
  int? percentageOff;
  int? isDelete;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['name'] = name;
    map['code'] = code;
    map['percentageOff'] = percentageOff;
    map['isDelete'] = isDelete;
    return map;
  }

}