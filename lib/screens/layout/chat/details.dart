import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/app/functions.dart';
import 'package:social_3c/controller/auth_ctrl.dart';
import 'package:social_3c/controller/chat_ctrl.dart';
import 'package:social_3c/model/user.dart';
import 'package:social_3c/screens/_resources/assets_path/icon_broken.dart';
import 'package:social_3c/screens/_resources/shared/loading_error_empty.dart';
import 'package:social_3c/screens/_resources/shared/toast.dart';
import 'package:social_3c/screens/layout/chat/widgets.dart';

import '../../../model/message.dart';

class ChatDetailsView extends StatefulWidget {
  const ChatDetailsView({
    required this.receiver,
    super.key,
  });

  final ChatModel receiver;

  @override
  State<ChatDetailsView> createState() => _ChatDetailsViewState();
}

class _ChatDetailsViewState extends State<ChatDetailsView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    context
        .read<ChatCtrl>()
        .updateUserStatus(true, widget.receiver.receiver.id);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      context.read<ChatCtrl>().updateUserStatus(
          false,
          widget.receiver.receiver
              .id); // User has put the app in the background or closed it
    } else if (state == AppLifecycleState.resumed) {
      context
          .read<ChatCtrl>()
          .updateUserStatus(true, widget.receiver.receiver.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sender = context.read<AuthCtrl>().myData;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.green.shade700,
              backgroundImage: NetworkImage(widget.receiver.receiver.imgUrl),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.receiver.receiver.name),
                Text(
                  widget.receiver.isOnline
                      ? "online"
                      : widget.receiver.lastSeen == "now"
                          ? "now"
                          : daysBetween(
                              DateTime.parse(widget.receiver.lastSeen)),
                  style: TextStyle(
                    color:
                        widget.receiver.isOnline ? Colors.green : Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: BlocBuilder<ChatCtrl, ChatStates>(
        builder: (context, state) {
          final cubit = context.read<ChatCtrl>();

          return Column(
            children: [
              Expanded(
                child: StreamBuilder<List<MessageModel>>(
                  stream: cubit.getMessages(
                    receiverId: widget.receiver.receiver.id,
                    senderId: sender!.id,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      final messages = snapshot.data;
                      if (messages == null || messages.isEmpty) {
                        return const LoadingErrorEmptyView(
                          state: CaseState.empty,
                          message: "Messages",
                        );
                      }
                      return Directionality(
                        textDirection: TextDirection.rtl,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            if (messages[index].sender.id == sender.id) {
                              return RightMessage(
                                messages[index].message,
                                messages[index].date,
                                onSelected: (selectedIndex) {
                                  if (selectedIndex == 0) {
                                    cubit.enableEdit(messages[index]);
                                  } else if (selectedIndex == 1) {
                                    cubit.deleteMessage(messages[index],
                                        index == messages.length - 1);
                                  }
                                },
                              );
                            }
                            return LeftMessage(
                              messages[index].message,
                              messages[index].date,
                            );
                          },
                          itemCount: messages.length,
                        ),
                      );
                    }
                    return const LoadingErrorEmptyView(
                      state: CaseState.loading,
                      message: "Messages",
                    );
                  },
                ),
              ),
              _sendItem(cubit, sender),
            ],
          );
        },
      ),
    );
  }

  Padding _sendItem(ChatCtrl cubit, UserModel? sender) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: cubit.messageCtrl,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Write your message...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              if (sender == null) {
                AppToast.error("Please Login first!");
              } else {
                if (cubit.message == null) {
                  cubit.sendMessage(
                    sender: sender,
                    receiver: widget.receiver.receiver,
                  );
                } else {
                  cubit.editMessage();
                }
              }
            },
            icon: Icon(
              cubit.message == null ? IconBroken.send : IconBroken.edit,
            ),
          ),
        ],
      ),
    );
  }
}
