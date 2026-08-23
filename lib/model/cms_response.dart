class CmsResponse {
  bool? success;
  String? message;
  CmsData? body;

  CmsResponse({this.success, this.message, this.body});

  CmsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    body = json['body'] != null ? CmsData.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class CmsData {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? title;
  String? version;
  String? effectiveDate;
  String? contentHtml;
  String? pdfUrl;
  dynamic type;

  CmsData({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.version,
    this.effectiveDate,
    this.contentHtml,
    this.pdfUrl,
    this.type,
  });

  CmsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    title = json['title'];
    version = json['version'];
    effectiveDate = json['effectiveDate'];
    type = json['type'];

    // Parse description/contentHtml from API
    contentHtml = json['description'] ?? json['contentHtml'];

    // Parse documentPath/pdfUrl from API and construct full URL if relative
    String? rawPath = json['documentPath'] ?? json['pdfUrl'];
    if (rawPath != null && rawPath.isNotEmpty) {
      if (!rawPath.startsWith('http')) {
        pdfUrl = "http://15.206.216.86:4005/" + (rawPath.startsWith('/') ? rawPath.substring(1) : rawPath);
      } else {
        pdfUrl = rawPath;
      }
    }
  }

  String getFormattedVersion() {
    if (version != null && version!.isNotEmpty) {
      return version!;
    }
    if (pdfUrl != null && pdfUrl!.contains('_v')) {
      final match = RegExp(r'_v([\d\.]+)\.pdf', caseSensitive: false).firstMatch(pdfUrl!);
      if (match != null && match.group(1) != null) {
        return match.group(1)!;
      }
    }
    return "1.0";
  }

  String getFormattedEffectiveDate() {
    if (effectiveDate != null && effectiveDate!.isNotEmpty) {
      return effectiveDate!;
    }
    final String? dateStr = updatedAt ?? createdAt;
    if (dateStr != null && dateStr.isNotEmpty) {
      try {
        final DateTime parsed = DateTime.parse(dateStr);
        const List<String> months = [
          'January', 'February', 'March', 'April', 'May', 'June',
          'July', 'August', 'September', 'October', 'November', 'December'
        ];
        return "${months[parsed.month - 1]} ${parsed.year}";
      } catch (_) {}
    }
    return "August 2026";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['title'] = title;
    data['version'] = version;
    data['effectiveDate'] = effectiveDate;
    data['contentHtml'] = contentHtml;
    data['description'] = contentHtml;
    data['pdfUrl'] = pdfUrl;
    data['documentPath'] = pdfUrl;
    data['type'] = type;
    return data;
  }
}
