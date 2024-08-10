import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/chat_ctrl.dart';
import 'package:social_3c/screens/_resources/shared/navigation.dart';
import 'package:social_3c/screens/layout/chat/details.dart';
import 'package:social_3c/screens/layout/chat/widgets.dart';

import '../../_resources/assets_path/icon_broken.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
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
        if (cubit.myUsers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  IconBroken.category,
                  color: Colors.grey,
                  size: 150,
                ),
                const SizedBox(height: 16),
                const Text(
                  'There is no users now!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                OutlinedButton(
                  onPressed: () {
                    cubit.getAllUsers();
                    _allUsersBottomSheet(context);
                  },
                  child: const Text("Connect to one"),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => cubit.getMyUsers(),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    return ChatItem(
                      img: cubit.myUsers[index].user.imgUrl,
                      name: cubit.myUsers[index].user.name,
                      lastMessage: cubit.myUsers[index].lastMessage,
                      date: cubit.myUsers[index].lastMessageDateTime.toString(),
                      onTap: () {
                        cubit.getUserChat(cubit.myUsers[index].user.id);

                        toPage(context,
                            ChatDetailsView(cubit.myUsers[index].user));
                      },
                    );
                  },
                  itemCount: cubit.myUsers.length,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  cubit.getAllUsers();
                  _allUsersBottomSheet(context);
                },
                child: const Text("New Chat"),
              ),
            ],
          ),
        );
      },
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
                      cubit.getUserChat(cubit.allUsers[index].id);
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
