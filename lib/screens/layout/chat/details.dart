import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/auth_ctrl.dart';
import 'package:social_3c/controller/chat_ctrl.dart';
import 'package:social_3c/model/user.dart';
import 'package:social_3c/screens/_resources/assets_path/icon_broken.dart';
import 'package:social_3c/screens/_resources/shared/toast.dart';
import 'package:social_3c/screens/layout/chat/widgets.dart';

import '../../../model/chat.dart';

class ChatDetailsView extends StatelessWidget {
  const ChatDetailsView(this.receiver, {super.key});

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
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                IconBroken.arrowLeft,
              ),
            ),
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(receiver.imgUrl),
            ),
            const SizedBox(width: 8),
            Text(
              receiver.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCtrl, ChatStates>(
              builder: (context, state) {
                final cubit = context.read<ChatCtrl>();

                return StreamBuilder<List<MessageModel>>(
                  stream: cubit.getUserChat(receiver.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      final messages = snapshot.data;

                      if (messages == null || messages.isEmpty) {
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
                                'There is no messages now,\nwrite a message',
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      }
                      return Directionality(
                        textDirection: TextDirection.rtl,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            if (sender!.id == messages[index].sender.id) {
                              return RightMessage(
                                messages[index].message,
                                DateTime.parse(messages[index].dateTime),
                              );
                            }
                            return LeftMessage(
                              messages[index].message,
                              DateTime.parse(messages[index].dateTime),
                            );
                          },
                          itemCount: messages.length,
                        ),
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
                            'Loading messages...',
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: context.read<ChatCtrl>().messageCtrl,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Write your message...",
                        hintStyle:
                            const TextStyle(color: Colors.grey, fontSize: 14)),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (sender == null) {
                      AppToast.error("please login first");
                    } else {
                      context.read<ChatCtrl>().sendMessage(
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
          )
        ],
      ),
    );
  }
}
