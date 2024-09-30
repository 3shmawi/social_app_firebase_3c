import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_3c/model/chat.dart';
import 'package:social_3c/model/message.dart';
import 'package:social_3c/screens/_resourses/toast.dart';

import '../model/user.dart';

class MessagesCtrl {
  final messageCtrl = TextEditingController();

  final _database = FirebaseFirestore.instance;

  void sendMessage({
    required UserModel sender,
    required UserModel receiver,
  }) async {
    if (messageCtrl.text.isEmpty) {
      AppToast.error("please type a message first");
      return;
    }
    final id = DateTime.now().toIso8601String();
    final messageData = MessageModel(
      id: id,
      message: messageCtrl.text,
      createdAt: id,
      sender: sender,
      receiver: receiver,
    );

    await _database
        .collection("Mohamed_Users")
        .doc(messageData.sender.id)
        .collection("users")
        .doc(messageData.receiver.id)
        .collection("messages")
        .doc(messageData.id)
        .set(messageData.toJson());

    messageCtrl.clear();

    await _database
        .collection("Mohamed_Users")
        .doc(messageData.receiver.id)
        .collection("users")
        .doc(messageData.sender.id)
        .collection("messages")
        .doc(messageData.id)
        .set(messageData.toJson());

    await _database
        .collection("Mohamed_Users")
        .doc(messageData.sender.id)
        .collection("users")
        .doc(messageData.receiver.id)
        .set(ChatModel(
          user: messageData.receiver,
          lastMessage: messageData.message,
          date: messageData.createdAt,
        ).toJson());

    await _database
        .collection("Mohamed_Users")
        .doc(messageData.receiver.id)
        .collection("users")
        .doc(messageData.sender.id)
        .set(ChatModel(
          user: messageData.sender,
          lastMessage: messageData.message,
          date: messageData.createdAt,
        ).toJson());
  }

  void deleteMessage() {}

  void editMessage() {}
}
