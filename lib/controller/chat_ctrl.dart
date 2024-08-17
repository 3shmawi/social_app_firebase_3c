import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/model/chat.dart';
import 'package:social_3c/screens/_resources/shared/toast.dart';

import '../model/user.dart';

//todo chat comming messages
class ChatCtrl extends Cubit<ChatStates> {
  ChatCtrl() : super(ChatInitialState());

  final _fireStore = FirebaseFirestore.instance;
  final _currentUser = FirebaseAuth.instance.currentUser;
  List<UserModel> allUsers = [];

  void getAllUsers() {
    emit(GetUsersLoadingState());

    _fireStore.collection('users').get().then((snapshot) {
      allUsers.clear();
      for (var doc in snapshot.docs) {
        if (_currentUser?.uid == doc.id) continue;
        allUsers.add(UserModel.fromMap(doc.data()));
      }
      emit(GetUsersSuccessState());
    }).catchError((error) {
      emit(GetUsersFailureState());
    });
  }

  List<UserChatModel> myUsers = [];

  Stream<List<UserChatModel>> getMyUsers() {
    return _fireStore
        .collection('Patrick_Users')
        .doc(_currentUser!.uid)
        .collection("users")
        .orderBy("lastMessageDateTime", descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return UserChatModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<MessageModel>> getUserChat(String userId) {
    return _fireStore
        .collection("Patrick_Users")
        .doc(_currentUser!.uid)
        .collection("users")
        .doc(userId)
        .collection("messages")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MessageModel.fromJson(doc.data());
      }).toList();
    });
  }

  //send message

  final messageCtrl = TextEditingController();

  void sendMessage({
    required UserModel sender,
    required UserModel receiver,
  }) async {
    if (messageCtrl.text.isEmpty) {
      AppToast.error("Write a message first");
      return;
    }
    final dateNow = DateTime.now().toIso8601String();
    final message = MessageModel(
      message: messageCtrl.text,
      sender: sender,
      receiver: receiver,
      messageId: dateNow,
      dateTime: dateNow,
    );

    await _fireStore
        .collection("Patrick_Users")
        .doc(sender.id)
        .collection("users")
        .doc(receiver.id)
        .collection("messages")
        .doc(dateNow)
        .set(message.toJson());
    messageCtrl.clear();

    await _fireStore
        .collection("Patrick_Users")
        .doc(receiver.id)
        .collection("users")
        .doc(sender.id)
        .set(
            UserChatModel(
              lastMessage: message.message,
              lastMessageDateTime: dateNow,
              user: sender,
            ).toJson(),
            SetOptions(
              merge: true,
            ));
    await _fireStore
        .collection("Patrick_Users")
        .doc(sender.id)
        .collection("users")
        .doc(receiver.id)
        .set(
            UserChatModel(
              lastMessage: message.message,
              lastMessageDateTime: dateNow,
              user: receiver,
            ).toJson(),
            SetOptions(
              merge: true,
            ));
    await _fireStore
        .collection("Patrick_Users")
        .doc(receiver.id)
        .collection("users")
        .doc(sender.id)
        .collection("messages")
        .doc(dateNow)
        .set(message.toJson());
  }
}

abstract class ChatStates {}

class ChatInitialState extends ChatStates {}

//users
class GetUsersLoadingState extends ChatStates {}

class GetUsersSuccessState extends ChatStates {}

class GetUsersFailureState extends ChatStates {}

//chats
class GetUserChatLoadingState extends ChatStates {}

class GetUserChatSuccessState extends ChatStates {}

class GetUserChatFailureState extends ChatStates {}
