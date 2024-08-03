import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/app/constants.dart';
import 'package:social_3c/model/user.dart';
import 'package:social_3c/screens/_resources/shared/toast.dart';
import 'package:social_3c/services/local_storage.dart';

class AuthCtrl extends Cubit<AuthStates> {
  AuthCtrl() : super(AuthInitialState());

  bool isPassword = true;

  void togglePassword() {
    isPassword = !isPassword;
    emit(ChangePasswordVisibilityState());
  }

  final userNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final _authCtrl = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;

  void login() {
    if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      AppToast.warning("Please fill in all fields");
      return;
    }
    emit(AuthLoadingState());
    _authCtrl
        .signInWithEmailAndPassword(
      email: emailCtrl.text,
      password: passwordCtrl.text,
    )
        .then((response) {
      CacheHelper.saveData(key: "myId", value: response.user!.uid);
      getProfileData(response.user!.uid);
      AppToast.success("Logged in successfully");
    }).catchError((error) {
      AppToast.error("Failed to login $error");
      emit(AuthFailureState());
    });
  }

  void _signup(String uid) {
    final newUser = UserModel(
      id: uid,
      email: emailCtrl.text,
      name: userNameCtrl.text,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      imgUrl: AppConstants.defaultProfileImg,
    );
    _fireStore
        .collection('users')
        .doc(uid)
        .set(newUser.toJson())
        .then((response) {
      myData = newUser;
      CacheHelper.saveData(key: "myId", value: newUser.id);

      AppToast.success("Created new user successfully");

      emit(GetProfileDataSuccessState());
    }).catchError((error) {
      AppToast.error("Failed to create new user $error");
      emit(AuthFailureState());
    });
  }

  void createUser() {
    if (emailCtrl.text.isEmpty ||
        passwordCtrl.text.isEmpty ||
        userNameCtrl.text.isEmpty) {
      AppToast.warning("Please fill in all fields");
      return;
    }
    emit(AuthLoadingState());
    _authCtrl
        .createUserWithEmailAndPassword(
      email: emailCtrl.text,
      password: passwordCtrl.text,
    )
        .then((response) {
      _signup(response.user!.uid);
    }).catchError((error) {
      AppToast.error("Failed to create new user $error");
      emit(AuthFailureState());
    });
  }

  Future<void> logout() async {
    return await _authCtrl.signOut();
  }

  //get profile data

  UserModel? myData;

  void getProfileData(String uid) {
    emit(GetProfileDataLoadingState());
    _fireStore.collection('users').doc(uid).get().then((response) {
      if (response.exists) {
        myData = UserModel.fromMap(response.data()!);
        emit(GetProfileDataSuccessState());
      } else {
        AppToast.warning("User not found");
        emit(GetProfileDataFailureState());
      }
    }).catchError((error) {
      AppToast.error("Failed to get profile data $error");
      emit(GetProfileDataFailureState());
    });
  }
}

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthLoadingState extends AuthStates {}

class AuthFailureState extends AuthStates {}

//profile data
class GetProfileDataLoadingState extends AuthStates {}

class GetProfileDataSuccessState extends AuthStates {}

class GetProfileDataFailureState extends AuthStates {}

class ChangePasswordVisibilityState extends AuthStates {}
