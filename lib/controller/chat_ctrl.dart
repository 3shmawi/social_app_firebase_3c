import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/model/message.dart';
import 'package:social_3c/model/user.dart';
import 'package:social_3c/screens/_resources/shared/toast.dart';
import 'package:social_3c/services/local_storage.dart';

class ChatCtrl extends Cubit<ChatStates> {
  ChatCtrl() : super(ChatInitialState());

  final _fireStore = FirebaseFirestore.instance;

  final myId = CacheHelper.getData(key: "myId");
  final messageCtrl = TextEditingController();

  void sendMessage({
    required UserModel sender,
    required UserModel receiver,
  }) {
    if (messageCtrl.text.isEmpty) {
      AppToast.error("Write a message first");
      return;
    }

    final newId = DateTime.now();
    final newMessage = MessageModel(
      messageId: newId.toIso8601String(),
      message: messageCtrl.text,
      date: newId,
      sender: sender,
      receiver: receiver,
    );
  }

  List<MessageModel> messages = [];

  List<ChatModel> myUsers = [];

  List<UserModel> allUsers = [];

  void getAllUsers() {
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
