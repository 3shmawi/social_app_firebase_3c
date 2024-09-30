import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/ctrl/auth_ctrl.dart';
import 'package:social_3c/ctrl/messages_ctrl.dart';
import 'package:social_3c/model/user.dart';
import 'package:social_3c/screens/_resourses/toast.dart';

class DetailsChatView extends StatelessWidget {
  const DetailsChatView(this.receiver, {super.key});
  final UserModel receiver;

  @override
  Widget build(BuildContext context) {
    final ctrl = MessagesCtrl();
    final sender = context.read<AuthCtrl>().myData;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
              ),
            ),
            const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 27,
              child: CircleAvatar(
                radius: 25,
              ),
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Name',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'online',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                ListView.builder(itemBuilder: (context, index) => ListTile()),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: ctrl.messageCtrl,
                ),
              ),
              IconButton(
                onPressed: () {
                  if (sender == null) {
                    AppToast.error("you must login to send message");
                  } else {
                    ctrl.sendMessage(sender: sender, receiver: receiver);
                  }
                },
                icon: const Icon(
                  Icons.send,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
