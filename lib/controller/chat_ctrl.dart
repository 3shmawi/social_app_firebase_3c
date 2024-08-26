import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/model/chat.dart';
import 'package:social_3c/screens/_resources/shared/toast.dart';

import '../model/user.dart';

class ChatCtrl extends Cubit<ChatStates> {
  ChatCtrl() : super(ChatInitialState());

  final _fireStore = FirebaseFirestore.instance;
  final _currentUser = FirebaseAuth.instance.currentUser;
  final messageCtrl = TextEditingController();

//send message

  void sendMessage(UserModel sender, UserModel receiver) async {
    if (messageCtrl.text.isEmpty) {
      AppToast.error("Please enter a message");
      return;
    }
    final date = DateTime.now();
    final newId = date.toIso8601String();
    final message = MessageModel(
      message: messageCtrl.text,
      sender: sender,
      receiver: receiver,
      date: newId,
      messageId: newId,
    );

    await _fireStore
        .collection("Bebo_Users")
        .doc(sender.id)
        .collection("users")
        .doc(receiver.id)
        .collection("messages")
        .doc(newId)
        .set(message.toMap());
    messageCtrl.clear();

    await _fireStore
        .collection("Bebo_Users")
        .doc(receiver.id)
        .collection("users")
        .doc(sender.id)
        .collection("messages")
        .doc(newId)
        .set(message.toMap());

    await _fireStore
        .collection("Bebo_Users")
        .doc(sender.id)
        .collection("users")
        .doc(receiver.id)
        .set(
          ChatModel(
            receiver: message.receiver,
            lastMessage: message.message,
            date: message.date,
          ).toMap(),
        );

    await _fireStore
        .collection("Bebo_Users")
        .doc(receiver.id)
        .collection("users")
        .doc(sender.id)
        .set(
          ChatModel(
            receiver: message.sender,
            lastMessage: message.message,
            date: message.date,
          ).toMap(),
        );
  }

//get messages
  Stream<List<MessageModel>> getMessages(String receiverId) {
    return _fireStore
        .collection("Bebo_Users")
        .doc(_currentUser!.uid)
        .collection("users")
        .doc(receiverId)
        .collection("messages")
        .orderBy("date")
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MessageModel.fromMap(doc.data()))
              .toList(),
        );
  }

// get my users
  Stream<List<ChatModel>> getMyUsers() {
    return _fireStore
        .collection('Bebo_Users')
        .doc(_currentUser!.uid)
        .collection('users')
        .orderBy("date", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatModel.fromMap(doc.data()))
              .toList(),
        );
  }

//get all users
  List<UserModel> allUsers = [];

  void getAllUsers() {
    emit(GetAllUsersLoadingState());
    _fireStore.collection('users').get().then(
      (snapshot) {
        allUsers.clear();
        for (var doc in snapshot.docs) {
          if (doc.id == _currentUser!.uid) continue;
          allUsers.add(UserModel.fromMap(doc.data()));
        }
        emit(GetAllUsersSuccessState());
      },
    ).catchError((error) {
      AppToast.error('Error getting documents: $error');
      emit(GetAllUsersErrorState());
    });
  }
}

abstract class ChatStates {}

class ChatInitialState extends ChatStates {}

class GetMessagesLoadingState extends ChatStates {}

class GetMessagesSuccessState extends ChatStates {}

class GetMessagesErrorState extends ChatStates {}

//get all users
class GetAllUsersLoadingState extends ChatStates {}

class GetAllUsersSuccessState extends ChatStates {}

class GetAllUsersErrorState extends ChatStates {}
