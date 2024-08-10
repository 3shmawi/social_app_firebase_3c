import 'package:flutter/material.dart';
import 'package:social_3c/screens/_resources/shared/navigation.dart';
import 'package:social_3c/screens/layout/chat/details.dart';
import 'package:social_3c/screens/layout/chat/widgets.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) {
        return ChatItem(
          img: "img",
          name: "name",
          lastMessage: "lastMessage",
          date: DateTime.now().toString(),
          onTap: () {
            toPage(context, const ChatDetailsView());
          },
        );
      },
    );
  }
}
