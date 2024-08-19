import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/auth_ctrl.dart';
import 'package:social_3c/controller/chat_ctrl.dart';
import 'package:social_3c/model/chat.dart';
import 'package:social_3c/model/user.dart';
import 'package:social_3c/screens/_resources/assets_path/icon_broken.dart';
import 'package:social_3c/screens/_resources/shared/loading_pop_up.dart';
import 'package:social_3c/screens/_resources/shared/toast.dart';
import 'package:social_3c/screens/layout/chat/widgets.dart';

class ChatDetailsView extends StatelessWidget {
  const ChatDetailsView(
    this.receiver, {
    super.key,
  });

  final UserModel receiver;

  @override
  Widget build(BuildContext context) {
    final sender = context.read<AuthCtrl>().myData;
    return BlocBuilder<ChatCtrl, ChatStates>(
      builder: (context, state) {
        final cubit = context.read<ChatCtrl>();
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
                  backgroundImage: NetworkImage(receiver.imgUrl),
                ),
                const SizedBox(width: 8),
                Text(receiver.name),
              ],
            ),
          ),
          body: Column(
            children: [
              StreamBuilder<List<MessageModel>>(
                stream: cubit.getMessages(receiver.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    final messages = snapshot.data;
                    if (messages == null || messages.isEmpty) {
                      return const Expanded(
                        child: AppCasesPopUp(
                          state: AppCases.empty,
                          message: "No Message Yes\nStart send a message",
                          icon: IconBroken.chat,
                        ),
                      );
                    }
                    return Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            if (messages[index].sender.id == sender!.id) {
                              return RightMessage(
                                messages[index].message,
                                messages[index].date,
                              );
                            }
                            return LeftMessage(
                              messages[index].message,
                              messages[index].date,
                            );
                          },
                          itemCount: messages.length,
                        ),
                      ),
                    );
                  }
                  return const Expanded(
                    child: AppCasesPopUp(state: AppCases.loading),
                  );
                },
              ),
              _sendItem(cubit, sender),
            ],
          ),
        );
      },
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
                cubit.sendMessage(
                  sender,
                  receiver,
                );
              }
            },
            icon: const Icon(
              IconBroken.send,
            ),
          ),
        ],
      ),
    );
  }
}
