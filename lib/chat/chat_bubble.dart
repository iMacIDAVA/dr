import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool sentByCurrentUser;
  const ChatBubble(
      {super.key, required this.message, required this.sentByCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(8),
              topRight: const Radius.circular(8),
              bottomLeft: sentByCurrentUser
                  ? const Radius.circular(8)
                  : const Radius.circular(0),
              bottomRight: sentByCurrentUser
                  ? const Radius.circular(0)
                  : const Radius.circular(8)),
          color: sentByCurrentUser ? Color(0xff0EBE7F) : Color(0xffCDD3DF)),
      child: Text(
        message,
        style: TextStyle(
            color: sentByCurrentUser ? Colors.white : const Color(0xff677294),
            fontWeight: FontWeight.w500,
            fontSize: 16),
      ),
    );
  }
}
