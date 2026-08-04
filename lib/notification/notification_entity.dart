class NotificationEntity {
  String? senderName;
  dynamic senderId;
  String? senderImage;
  String? sender_name;
  String? contentAvailable;
  dynamic receiverId;
  dynamic senderRole;
  dynamic receiverRole;
  dynamic receiverImage;
  dynamic receiverName;
  dynamic notificationType;
  dynamic receiverChatStatus;
  dynamic type;
  dynamic chat_room_id;
  dynamic group_id;
  String? priority;
  String? body;
  String? title;
  String? postId;
  String? group_image;
  String? group_name;
  dynamic isAdmin;
  dynamic data_to_send;

  NotificationEntity(
      {this.senderName,
        this.senderId,
        this.senderRole,
        this.sender_name,
        this.receiverChatStatus,
        this.senderImage,
        this.contentAvailable,
        this.receiverId,
        this.receiverRole,
        this.receiverImage,
        this.notificationType,
        this.priority,
        this.body,
        this.title,
        this.postId,
        this.type,
        this.receiverName,
        this.chat_room_id,
        this.group_image,
        this.group_name,
        this.isAdmin,
        this.group_id,
        this.data_to_send,

      });

  NotificationEntity.fromJson(Map<String, dynamic> json) {
    senderName = json['sender_name'];
    senderId = json['senderId'];
    receiverChatStatus = json['receiverChatStatus'];
    senderRole = json['senderRole'];
    senderImage = json['sender_image'];
    contentAvailable = json['content_available'];
    receiverId = json['Receiver_id'];
    receiverRole = json['receiverRole'];
    receiverImage = json['Receiver_image'];
    receiverName = json['Receiver_name'];
    notificationType = json['notification_type'];
    priority = json['priority'];
    body = json['body'];
    title = json['title'];
    postId = json['postId'];
    type = json['type'];
    chat_room_id = json['chat_room_id'];
    group_image = json['group_image'];
    isAdmin = json['isAdmin'];
    group_name = json['group_name'];
    group_id = json['group_id'];
    data_to_send = json['data_to_send'];
    // data_to_send = json['data_to_send'] != null
    //     ? MessageModel.fromJson(json['data_to_send'])
    //     : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sender_name'] = senderName;
    data['senderId'] = senderId;
    data['chat_room_id'] = chat_room_id;
    data['receiverChatStatus'] = receiverChatStatus;
    data['sender_image'] = senderImage;
    data['content_available'] = contentAvailable;
    data['Receiver_id'] = receiverId;
    data['receiverRole'] = receiverRole;
    data['senderRole'] = senderRole;
    data['Receiver_image'] = receiverImage;
    data['Receiver_name'] = receiverName;
    data['notification_type'] = notificationType;
    data['priority'] = priority;
    data['body'] = body;
    data['title'] = title;
    data['postId'] = postId;
    data['type'] = type;
    data['group_image'] = group_image;
    data['group_name'] = group_name;
    data['isAdmin'] = isAdmin;
    data['group_id'] = group_id;
    data['data_to_send'] = data_to_send;
    data.removeWhere((key, value) => value=="" || value==null);
    return data;
  }
}