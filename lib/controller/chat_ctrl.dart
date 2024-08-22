import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/model/message.dart';
import 'package:social_3c/model/user.dart';
import 'package:social_3c/screens/_resources/shared/toast.dart';
import 'package:social_3c/services/local_storage.dart';

class ChatCtrl extends Cubit<ChatStates> {
  ChatCtrl() : super(ChatInitialState());

  final _fireStore = FirebaseFirestore.instance;
  String myId = FirebaseAuth.instance.currentUser!.uid;

  final messageCtrl = TextEditingController();

  void sendMessage({
    required UserModel sender,
    required UserModel receiver,
  }) async {
    if (messageCtrl.text.isEmpty) {
      AppToast.error("Write a message first");
      return;
    }

    final date = DateTime.now();
    final newId = date.toIso8601String();

    final newMessage = MessageModel(
      messageId: newId,
      message: messageCtrl.text,
      date: newId,
      sender: sender,
      receiver: receiver,
    );
    await _fireStore
        .collection("MYM_USERS")
        .doc(sender.id)
        .collection("users")
        .doc(receiver.id)
        .collection("messages")
        .doc(newId)
        .set(newMessage.toMap());

    messageCtrl.clear();

    await _fireStore
        .collection("MYM_USERS")
        .doc(receiver.id)
        .collection("users")
        .doc(sender.id)
        .collection("messages")
        .doc(newId)
        .set(newMessage.toMap());

    await _fireStore
        .collection("MYM_USERS")
        .doc(receiver.id)
        .collection("users")
        .doc(sender.id)
        .set(ChatModel(
          receiver: newMessage.sender,
          lastMessage: newMessage.message,
          date: newId,
        ).toMap());

    await _fireStore
        .collection("MYM_USERS")
        .doc(sender.id)
        .collection("users")
        .doc(receiver.id)
        .set(ChatModel(
          receiver: newMessage.receiver,
          lastMessage: newMessage.message,
          date: newId,
        ).toMap());
  }

  void editMessage({
    required MessageModel message,
  }) async {
    if (messageCtrl.text.isEmpty) {
      AppToast.error("Write a message first");
      return;
    }

    final newMessage = MessageModel(
      messageId: message.messageId,
      message: messageCtrl.text,
      date: message.date,
      sender: message.sender,
      receiver: message.receiver,
    );
    await _fireStore
        .collection("MYM_USERS")
        .doc(message.sender.id)
        .collection("users")
        .doc(message.receiver.id)
        .collection("messages")
        .doc(message.messageId)
        .update(newMessage.toMap());

    messageCtrl.clear();

    await _fireStore
        .collection("MYM_USERS")
        .doc(message.receiver.id)
        .collection("users")
        .doc(message.sender.id)
        .collection("messages")
        .doc(message.messageId)
        .update(newMessage.toMap());

    await _fireStore
        .collection("MYM_USERS")
        .doc(message.receiver.id)
        .collection("users")
        .doc(message.sender.id)
        .set(ChatModel(
          receiver: newMessage.sender,
          lastMessage: newMessage.message,
          date: message.date,
        ).toMap());

    await _fireStore
        .collection("MYM_USERS")
        .doc(message.sender.id)
        .collection("users")
        .doc(message.receiver.id)
        .set(ChatModel(
          receiver: newMessage.receiver,
          lastMessage: newMessage.message,
          date: message.date,
        ).toMap());
  }

  Stream<List<MessageModel>> getMessages({
    required String receiverId,
    required String senderId,
  }) {
    return _fireStore
        .collection("MYM_USERS")
        .doc(receiverId)
        .collection("users")
        .doc(senderId)
        .collection("messages")
        .orderBy("date")
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => MessageModel.fromMap(doc.data()),
              )
              .toList(),
        );
  }

  Stream<List<ChatModel>> getMyUsers() {
    return _fireStore
        .collection("MYM_USERS")
        .doc(myId)
        .collection("users")
        .orderBy("date", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ChatModel.fromMap(doc.data()),
              )
              .toList(),
        );
  }

  List<UserModel> allUsers = [];

  void getAllUsers() {
    String myId = CacheHelper.getData(key: "myId");
    emit(GetAllUsersLoadingState());
    _fireStore.collection('users').get().then((value) {
      allUsers.clear();

      for (var doc in value.docs) {
        if (doc.id == myId) continue;
        allUsers.add(UserModel.fromMap(doc.data()));
      }

      emit(GetAllUsersSuccessState());
    }).catchError((error) {
      emit(GetAllUsersFailureState());
      AppToast.error("Failed to get users: $error");
    });
  }
}

abstract class ChatStates {}

class ChatInitialState extends ChatStates {}

//messages
class GetMessagesLoadingState extends ChatStates {}

class GetMessagesSuccessState extends ChatStates {}

class GetMessagesFailureState extends ChatStates {}

//my users
class GetMyUsersLoadingState extends ChatStates {}

class GetMyUsersSuccessState extends ChatStates {}

class GetMyUsersFailureState extends ChatStates {}

//all users
class GetAllUsersLoadingState extends ChatStates {}

class GetAllUsersSuccessState extends ChatStates {}

class GetAllUsersFailureState extends ChatStates {}
