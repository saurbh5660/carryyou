class BannerListResponse {
  BannerListResponse({
    this.success,
    this.code,
    this.message,
    this.body,
  });

  BannerListResponse.fromJson(dynamic json) {
    // API may return either a wrapped object or directly a list.
    if (json is List) {
      body = json.map((e) => BannerItem.fromJson(e)).toList();
      return;
    }

    success = json['success'];
    code = json['code'];
    message = json['message'];

    final dynamic rawBody = json['body'] ?? json['data'] ?? json['result'];
    if (rawBody is List) {
      body = rawBody.map((e) => BannerItem.fromJson(e)).toList();
    } else {
      body = const <BannerItem>[];
    }
  }

  bool? success;
  int? code;
  String? message;
  List<BannerItem>? body;

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

class BannerItem {
  BannerItem({
    this.id,
    this.title,
    this.image,
    this.redirectUrl,
    this.status,
  });

  BannerItem.fromJson(dynamic json) {
    if (json == null) return;

    // Common shapes supported:
    // {id, title, image, redirectUrl, status}
    // {bannerImage, link, isActive}
    id = (json['id'] ?? json['_id'] ?? json['bannerId'])?.toString();
    title = (json['title'] ?? json['name'] ?? json['bannerTitle'])?.toString();
    image = (json['image'] ??
            json['bannerImage'] ??
            json['imageUrl'] ??
            json['bannerUrl'] ??
            json['file'])?.toString();
    redirectUrl =
        (json['redirectUrl'] ?? json['link'] ?? json['url'])?.toString();
    status = json['status'] ?? json['isActive'] ?? json['active'];
  }

  String? id;
  String? title;
  String? image;
  String? redirectUrl;
  dynamic status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['image'] = image;
    map['redirectUrl'] = redirectUrl;
    map['status'] = status;
    return map;
  }
}

