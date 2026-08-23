class CmsPdfResponse {
  bool? success;
  num? code;
  String? message;
  CmsPdfBody? body;

  CmsPdfResponse({this.success, this.code, this.message, this.body});

  CmsPdfResponse.fromJson(dynamic json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null ? CmsPdfBody.fromJson(json['body']) : null;
  }

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

class CmsPdfBody {
  String? pdfUrl;

  CmsPdfBody({this.pdfUrl});

  CmsPdfBody.fromJson(dynamic json) {
    pdfUrl = json['pdfUrl'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pdfUrl'] = pdfUrl;
    return map;
  }
}
