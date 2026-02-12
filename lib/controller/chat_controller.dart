import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../common/db_helper.dart';
import '../common/socket_service.dart';
import '../model/chat_message.dart';

class ChatController extends GetxController implements SocketListener {
  final SocketService socketService = SocketService();
  final TextEditingController msgInputController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  var messages = <ChatMessage>[].obs;

  late String receiverId;
  late String receiverName;
  late String receiverImage;
  late String myId;

  @override
  void onInit() {
    super.onInit();
    myId = DbHelper().getUserModel()?.id.toString() ?? "";

    receiverId = Get.arguments['id']?.toString() ?? "";
    receiverName = Get.arguments['name'] ?? "User";
    receiverImage = Get.arguments['image'] ?? "";
    socketService.setListener(this);

    fetchChatHistory();
  }

  @override
  void onSocketEvent(dynamic data, String eventType) {
    try {
      Logger().d("dsgvdsgdsgbdg");
      if (data == null) {
        debugPrint("Socket Error: Received null data for event $eventType");
        return;
      }

      if (eventType == 'send_message_emit') {
        // Ensure data is a Map before parsing
        if (data is Map<String, dynamic>) {
          messages.add(ChatMessage.fromJson(data, myId));
          _scrollToBottom();
        } else {
          debugPrint("Socket Error: Expected Map for send_message_emit but got ${data.runtimeType}");
        }
      }

      else if (eventType == 'users_chat_list_listener') {
        // Ensure data is a List before mapping
        if (data is List) {
          var history = data
              .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>, myId))
              .toList();

          messages.assignAll(history);
          _scrollToBottom();
        } else {
          debugPrint("Socket Error: Expected List for chat_list but got ${data.runtimeType}");
        }
      }
    } catch (e, stackTrace) {
      // Log the error and the stack trace to find exactly where the parsing failed
      debugPrint("Error in onSocketEvent ($eventType): $e");
      debugPrint("Stacktrace: $stackTrace");

      // Optional: Show a toast or snackbar to the user if the error is critical
      // Get.snackbar("Error", "Failed to load messages", snackPosition: SnackPosition.BOTTOM);
    }
  }

  void fetchChatHistory() {
    Logger().d("doneegdfdggdddd");
    Map<String, dynamic> msgData = {
      'senderId': myId,
      'receiverId': receiverId,
    };
    socketService.getMessages(msgData);
    Logger().d("ffffffffffffff-----  "+msgData.toString());

  }

  void onSend() {
    Logger().d("fdsdsfsdggsgdddd");
    if (msgInputController.text.trim().isEmpty) return;

    Map<String, dynamic> msgData = {
      'senderId': myId,
      'receiverId': receiverId,
      'message': msgInputController.text.trim(),
      'message_type': "1"
    };
    Logger().d("ffffffffffffff-----  "+msgData.toString());
    socketService.sendMessage(msgData);
    msgInputController.clear();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
