import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/chat_ctrl.dart';
import 'package:social_3c/screens/_resources/shared/loading_error_empty.dart';
import 'package:social_3c/screens/_resources/shared/navigation.dart';
import 'package:social_3c/screens/layout/chat/details.dart';
import 'package:social_3c/screens/layout/chat/widgets.dart';

import '../../../model/message.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCtrl, ChatStates>(
      builder: (context, state) {
        final cubit = context.read<ChatCtrl>();
        return Scaffold(
          body: StreamBuilder<List<ChatModel>>(
            stream: ChatCtrl().getMyUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                final myUsers = snapshot.data;
                if (myUsers == null || myUsers.isEmpty) {
                  return const LoadingErrorEmptyView(
                    state: CaseState.empty,
                    message: "Users",
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    return ChatItem(
                      img: myUsers[index].receiver.imgUrl,
                      name: myUsers[index].receiver.name,
                      lastMessage: myUsers[index].lastMessage,
                      date: myUsers[index].date,
                      onTap: () {
                        toPage(
                          context,
                          ChatDetailsView(
                            receiver: myUsers[index].receiver,
                          ),
                        );
                      },
                    );
                  },
                  itemCount: myUsers.length,
                );
              }

              return const LoadingErrorEmptyView(
                state: CaseState.loading,
                message: "Users",
              );
            },
          ),
          // body: state is GetMyUsersLoadingState
          //     ?
          //     : state is GetMyUsersFailureState
          //         ? const LoadingErrorEmptyView(
          //             state: CaseState.error,
          //             message: "Users",
          //           )
          //         : myUsers.isEmpty
          //             ?
          //             :
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              cubit.getAllUsers();
              showModalBottomSheet(
                context: context,
                builder: (context) => BlocBuilder<ChatCtrl, ChatStates>(
                  builder: (context, state) {
                    final cubit = context.read<ChatCtrl>();
                    final allUsers = cubit.allUsers;
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
                            child: state is GetAllUsersLoadingState
                                ? const LoadingErrorEmptyView(
                                    state: CaseState.loading,
                                    message: "Users",
                                  )
                                : state is GetAllUsersFailureState
                                    ? const LoadingErrorEmptyView(
                                        state: CaseState.error,
                                        message: "Users",
                                      )
                                    : allUsers.isEmpty
                                        ? const LoadingErrorEmptyView(
                                            state: CaseState.empty,
                                            message: "Users",
                                          )
                                        : ListView.builder(
                                            padding: const EdgeInsets.all(10),
                                            itemBuilder: (context, index) {
                                              return ChatItem(
                                                img: allUsers[index].imgUrl,
                                                name: allUsers[index].name,
                                                lastMessage:
                                                    "Start with a message",
                                                date: DateTime.now().toString(),
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                  toPage(
                                                    context,
                                                    ChatDetailsView(
                                                      receiver: allUsers[index],
                                                    ),
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
