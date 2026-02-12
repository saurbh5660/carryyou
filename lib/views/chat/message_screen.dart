import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';

class MessagesScreen extends StatelessWidget {
  MessagesScreen({super.key});

  final List<MessageItem> messages = [
    MessageItem(
      name: 'John Smith',
      message: 'Great ! Thank you so much',
      time: '11:34 PM',
      image: 'https://i.pravatar.cc/150?img=1',
    ),
    MessageItem(
      name: 'William Gate',
      message: 'Where are You ?',
      time: '11:34 PM',
      image: 'https://i.pravatar.cc/150?img=2',
    ),
    MessageItem(
      name: 'Jyllie Johnson',
      message: 'Where are You ?',
      time: 'Yesterday',
      image: 'https://i.pravatar.cc/150?img=3',
    ),
    MessageItem(
      name: 'John Smith',
      message: 'Great ! Thank you so much',
      time: 'Yesterday',
      image: 'https://i.pravatar.cc/150?img=4',
    ),
    MessageItem(
      name: 'William Gate',
      message: 'Where are You ?',
      time: 'Tuesday',
      image: 'https://i.pravatar.cc/150?img=5',
    ),
    MessageItem(
      name: 'Jyllie Johnson',
      message: 'Where are You ?',
      time: 'Tuesday',
      image: 'https://i.pravatar.cc/150?img=6',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Messages',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.separated(
          itemCount: messages.length,
          physics: AlwaysScrollableScrollPhysics(),
          separatorBuilder: (_, __) => Divider(
            height: 1,
            color: Colors.grey.shade300,
          ),
          itemBuilder: (context, index) {
            return _messageTile(messages[index]);
          },
        ),
      ),
    );
  }

  /// ================= MESSAGE TILE =================
  Widget _messageTile(MessageItem item) {
    return GestureDetector(
      onTap: (){
        Get.toNamed(AppRoutes.chatScreen);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(item.image),
            ),
            const SizedBox(width: 12),

            /// Name + Message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            /// Time
            Text(
              item.time,
              style: GoogleFonts.montserrat(
                fontSize: 10,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ================= MODEL =================
class MessageItem {
  final String name;
  final String message;
  final String time;
  final String image;

  MessageItem({
    required this.name,
    required this.message,
    required this.time,
    required this.image,
  });
}
