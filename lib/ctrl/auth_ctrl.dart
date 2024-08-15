import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/model/user.dart';

class AuthCtrl extends Cubit<AuthStates> {
  AuthCtrl() : super(AuthInitialState());

  final _auth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;

  UserModel? myData;

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

// ab
  void login() {
    emit(AuthLoadingState());
    _auth
        .signInWithEmailAndPassword(
      email: emailCtrl.text.trim(),
      password: passwordCtrl.text,
    )
        .then((response) {
      getMyData(response.user!.uid, true);
    }).catchError((error) {
      emit(AuthErrorState());
    });
  }

  void register() {
    emit(AuthLoadingState());
    _auth
        .createUserWithEmailAndPassword(
      email: emailCtrl.text.trim(),
      password: passwordCtrl.text,
    )
        .then((response) {
      _createUser(response.user!.uid);
    }).catchError((error) {
      emit(AuthErrorState());
    });
  }

  void _createUser(String userId) {
    final newUser = UserModel(
      userId: userId,
      userName: nameCtrl.text,
      email: emailCtrl.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      profileImgUrl: "",
    );

    _database
        .collection("users")
        .doc(userId)
        .set(newUser.toJson())
        .then((response) {
      myData = newUser;
      emit(AuthSuccessAndGettingDataState());
    }).catchError((error) {
      emit(AuthErrorState());
    });
  }

  Future logout() async {
    myData = null;
    return await _auth.signOut();
  }

  //authentication
  //my data
  void getMyData(String myId, [bool isFromAuth = false]) {
    if (!isFromAuth) {
      emit(GetProfileDataLoadingState());
    }
    _database.collection("users").doc(myId).get().then((response) {
      myData = UserModel.fromJson(response.data()!);
      emit(AuthSuccessAndGettingDataState());
    }).catchError((error) {
      emit(AuthErrorState());
    });
  }

  //other logic

  bool isPassword = true;

  void showPassword() {
    isPassword = !isPassword;
    emit(ShowPasswordState());
  }
}

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthLoadingState extends AuthStates {}

class AuthSuccessAndGettingDataState extends AuthStates {}

class AuthErrorState extends AuthStates {}

//my data
class GetProfileDataLoadingState extends AuthStates {}

//other logic
class ShowPasswordState extends AuthStates {}
