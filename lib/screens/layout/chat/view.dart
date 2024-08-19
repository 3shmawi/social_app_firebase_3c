import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/chat_ctrl.dart';
import 'package:social_3c/model/chat.dart';
import 'package:social_3c/screens/_resources/assets_path/icon_broken.dart';
import 'package:social_3c/screens/_resources/shared/loading_pop_up.dart';
import 'package:social_3c/screens/_resources/shared/navigation.dart';
import 'package:social_3c/screens/layout/chat/details.dart';
import 'package:social_3c/screens/layout/chat/widgets.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCtrl, ChatStates>(
      builder: (context, state) {
        final cubit = context.read<ChatCtrl>();
        return Scaffold(
          body: StreamBuilder<List<ChatModel>>(
            stream: cubit.getMyUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                final myUsers = snapshot.data;
                if (myUsers == null || myUsers.isEmpty) {
                  return const AppCasesPopUp(
                    state: AppCases.empty,
                    message: "No users found\nState chat with new one",
                    icon: IconBroken.user1,
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    return ChatItem(
                      img: myUsers[index].receiver.imgUrl,
                      name: myUsers[index].receiver.name,
                      lastMessage: myUsers[index].lastMessage,
                      date: myUsers[index].date.toString(),
                      onTap: () {
                        toPage(
                          context,
                          ChatDetailsView(myUsers[index].receiver),
                        );
                      },
                    );
                  },
                  itemCount: myUsers.length,
                );
              }
              return const AppCasesPopUp(state: AppCases.loading);
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              cubit.getAllUsers();
              showModalBottomSheet(
                context: context,
                builder: (context) => BlocBuilder<ChatCtrl, ChatStates>(
                  builder: (context, state) {
                    if (state is GetAllUsersLoadingState) {
                      return const AppCasesPopUp(state: AppCases.loading);
                    }
                    if (state is GetMessagesErrorState) {
                      return const AppCasesPopUp(
                        state: AppCases.failure,
                        message: "Error while getting all users",
                      );
                    }

                    final allUsers = context.read<ChatCtrl>().allUsers;
                    if (allUsers.isEmpty) {
                      return const AppCasesPopUp(
                        state: AppCases.empty,
                        message: "No users found, please try again later",
                        icon: IconBroken.user,
                      );
                    }
                    return Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(
                            15,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "New Chat",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade900,
                              ),
                            ),
                          ),
                          const Divider(
                            color: Colors.green,
                            height: 0,
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(10),
                              itemBuilder: (context, index) {
                                return ChatItem(
                                  img: allUsers[index].imgUrl,
                                  name: allUsers[index].name,
                                  lastMessage: "Start with a message",
                                  date: DateTime.now().toString(),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    toPage(
                                      context,
                                      ChatDetailsView(allUsers[index]),
                                    );
                                  },
                                );
                              },
                              itemCount: allUsers.length,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
