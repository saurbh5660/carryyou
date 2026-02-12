class CommonResponse {
  CommonResponse({
      this.success, 
      this.code, 
      this.message, 
      this.body,});

  CommonResponse.fromJson(dynamic json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    body = json['body'];
  }
  bool? success;
  num? code;
  String? message;
  dynamic body;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['code'] = code;
    map['message'] = message;
    map['body'] = body;
    return map;
  }

}