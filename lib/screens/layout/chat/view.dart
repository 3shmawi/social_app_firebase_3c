import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/chat_ctrl.dart';
import 'package:social_3c/screens/_resources/shared/navigation.dart';
import 'package:social_3c/screens/layout/chat/details.dart';
import 'package:social_3c/screens/layout/chat/widgets.dart';

import '../../../model/chat.dart';
import '../../_resources/assets_path/icon_broken.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ChatCtrl, ChatStates>(
        builder: (context, state) {
          final cubit = context.read<ChatCtrl>();

          return StreamBuilder<List<UserChatModel>>(
            stream: cubit.getMyUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                final users = snapshot.data;
                if (users == null || users.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          IconBroken.category,
                          color: Colors.grey,
                          size: 150,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'There is no users now!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        Text("Connect to one")
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    return ChatItem(
                      img: users[index].user.imgUrl,
                      name: users[index].user.name,
                      lastMessage: users[index].lastMessage,
                      date: users[index].lastMessageDateTime.toString(),
                      onTap: () {
                        toPage(context, ChatDetailsView(users[index].user));
                      },
                    );
                  },
                  itemCount: cubit.myUsers.length,
                );
              }
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.green,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading users...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ChatCtrl>().getAllUsers();
          _allUsersBottomSheet(context);
        },
        child: const Icon(Icons.people, color: Colors.white, size: 32),
      ),
    );
  }

  //bottom sheet model
  _allUsersBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return BlocBuilder<ChatCtrl, ChatStates>(
            builder: (context, state) {
              if (state is GetUsersLoadingState) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.green,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Loading users...',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (state is GetUsersFailureState) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 150,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Error while fetching users',
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
                    ],
                  ),
                );
              }

              final cubit = context.read<ChatCtrl>();
              if (cubit.allUsers.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        IconBroken.category,
                        color: Colors.grey,
                        size: 150,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'There is no users now!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  return ChatItem(
                    img: cubit.allUsers[index].imgUrl,
                    name: cubit.allUsers[index].name,
                    lastMessage: "Start a new chat",
                    date: DateTime.now().toString(),
                    onTap: () {
                      Navigator.of(context).pop();
                      toPage(context, ChatDetailsView(cubit.allUsers[index]));
                    },
                  );
                },
                itemCount: cubit.allUsers.length,
              );
            },
          );
        });
  }
}
