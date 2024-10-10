import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_3c/ctrl/chat_ctrl.dart';
import 'package:social_3c/model/user.dart';
import 'package:social_3c/screens/_resourses/navigation.dart';
import 'package:social_3c/screens/layout/chat/details_chat_view.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context, builder: (context) => const AllUsersBottom());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AllUsersBottom extends StatelessWidget {
  const AllUsersBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ChatCtrl().getAllUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final users = snapshot.data;
          if (users == null || users.isEmpty) {
            return const Text('No users found');
          }
          return ListView.builder(
            itemBuilder: (context, index) => _ChatItem(users[index]),
            itemCount: users.length,
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
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
      child: Card(
        margin: const EdgeInsets.all(10),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(user.imgUrl),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text(
                      'last message',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const Text(
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
