import 'package:carry_you_user/network/api_constants.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isMe;
  final String image;
  final String senderId;
  final String receiverId;
  final String time;
  final int messageType; // Added based on your JSON (0 for text)

  ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.image,
    required this.senderId,
    required this.receiverId,
    required this.time,
    required this.messageType,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json, String currentUserId) {
    final String sId = json['senderId']?.toString() ?? "";
    final String rId = json['receiverId']?.toString() ?? "";
    final bool me = sId == currentUserId;

    final Map<String, dynamic>? senderObj = json['sender'];
    final Map<String, dynamic>? receiverObj = json['receiver'];

    String relativePath = senderObj?['profilePicture'] ?? "";

    const String baseUrl = ApiConstants.userImageUrl;
    String fullImageUrl = relativePath.isNotEmpty
        ? (relativePath.startsWith('http') ? relativePath : "$baseUrl$relativePath")
        : "";

    return ChatMessage(
      id: json['id']?.toString() ?? "",
      text: json['message'] ?? "",
      isMe: me,
      senderId: sId,
      receiverId: rId,
      image: fullImageUrl,
      messageType: json['messageType'] ?? 0,
      time: _formatDateTime(json['createdAt']),
    );
  }

  static String _formatDateTime(String? dateStr) {
    if (dateStr == null) return "";
    try {
      DateTime dt = DateTime.parse(dateStr).toLocal();
      int hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      String minute = dt.minute.toString().padLeft(2, '0');
      String amPm = dt.hour >= 12 ? "PM" : "AM";
      return "$hour:$minute $amPm";
    } catch (e) {
      return "10:26 AM";
    }
  }
}