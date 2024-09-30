import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_3c/model/user.dart';
import 'package:social_3c/screens/_resourses/navigation.dart';
import 'package:social_3c/screens/layout/chat/details_chat_view.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => _ChatItem(
        UserModel(
          id: "id",
          email: "email",
          name: "name",
          createdAt: Timestamp.now(),
          updatedAt: Timestamp.now(),
          imgUrl: "imgUrl",
        ),
      ),
      itemCount: 13,
    );
  }
}

class _ChatItem extends StatelessWidget {
  const _ChatItem(this.user);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => push(context, DetailsChatView(user)),
      child: const Card(
        margin: EdgeInsets.all(10),
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Name',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'last message',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Text(
                'Time',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
