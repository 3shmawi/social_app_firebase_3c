import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/auth_ctrl.dart';
import 'package:social_3c/controller/chat_ctrl.dart';
import 'package:social_3c/model/user.dart';
import 'package:social_3c/screens/_resources/assets_path/icon_broken.dart';
import 'package:social_3c/screens/_resources/shared/loading_error_empty.dart';
import 'package:social_3c/screens/_resources/shared/toast.dart';
import 'package:social_3c/screens/layout/chat/widgets.dart';

class ChatDetailsView extends StatelessWidget {
  const ChatDetailsView({
    required this.receiver,
    super.key,
  });

  final UserModel receiver;

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
              backgroundImage: NetworkImage(receiver.imgUrl),
            ),
            const SizedBox(width: 8),
            Text(receiver.name),
          ],
        ),
      ),
      body: BlocBuilder<ChatCtrl, ChatStates>(
        builder: (context, state) {
          final cubit = context.read<ChatCtrl>();
          if (state is GetMessagesLoadingState) {
            return LoadingErrorEmptyView(
              state: CaseState.loading,
              message: "Messages",
              child: _sendItem(cubit, sender),
            );
          }
          if (state is GetMessagesFailureState) {
            return LoadingErrorEmptyView(
              state: CaseState.error,
              message: "Messages",
              child: _sendItem(cubit, sender),
            );
          }

          if (cubit.messages.isEmpty) {
            return LoadingErrorEmptyView(
              state: CaseState.empty,
              message: "Messages",
              child: _sendItem(cubit, sender),
            );
          }
          return Column(
            children: [
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      if (cubit.messages[index].sender == sender) {
                        return RightMessage(
                          cubit.messages[index].message,
                          cubit.messages[index].date,
                        );
                      }
                      return LeftMessage(
                        cubit.messages[index].message,
                        cubit.messages[index].date,
                      );
                    },
                    itemCount: cubit.messages.length,
                  ),
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
                cubit.sendMessage(
                  sender: sender,
                  receiver: receiver,
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
