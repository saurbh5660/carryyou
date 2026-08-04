class PromoCodeResponse {
  PromoCodeResponse({
      this.success, 
      this.code, 
      this.message,
      this.body,});

  PromoCodeResponse.fromJson(dynamic json) {
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
      this.name, 
      this.code, 
      this.percentageOff, 
      this.isDelete,});

  Body.fromJson(dynamic json) {
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