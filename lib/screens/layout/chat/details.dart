import 'package:flutter/material.dart';
import 'package:social_3c/screens/layout/chat/widgets.dart';

class ChatDetailsView extends StatelessWidget {
  const ChatDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Details'),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          itemBuilder: (context, index) {
            if (index % 4 == 0) {
              return RightMessage("message", DateTime.now());
            }
            return LeftMessage("message", DateTime.now());
          },
        ),
      ),
    );
  }
}
