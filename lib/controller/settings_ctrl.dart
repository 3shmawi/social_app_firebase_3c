import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_3c/model/user.dart';
import 'package:social_3c/screens/_resources/shared/toast.dart';

class SettingsCtrl extends Cubit<SettingsStates> {
  SettingsCtrl() : super(InitialSettingsState());

  final userNameCtrl = TextEditingController();
  final bioCtrl = TextEditingController();

  final _database = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _picker = ImagePicker();

  XFile? selectedImage;
  String? imgUrl;

  void editUserData(UserModel user) async {
    if (userNameCtrl.text.isEmpty || bioCtrl.text.isEmpty) {
      AppToast.error("Please fill in all fields");
      return;
    }

    emit(EditUserDataLoadingState());
    if (selectedImage != null) {
      imgUrl = await _uploadImage(File(selectedImage!.path));
    }
    _database.collection("users").doc(user.id).update({
      'username': userNameCtrl.text,
      'bio': bioCtrl.text,
      'imgUrl': imgUrl,
    }).then((_) {
      userNameCtrl.clear();
      bioCtrl.clear();
      selectedImage = null;
      imgUrl = null;
      AppToast.success("Updated user data successfully");
      emit(EditUserDataSuccessState());
    }).catchError((error) {
      AppToast.error("Failed to update user data");
      emit(EditUserDataErrorState());
    });
  }

  Future<void> pickImage() async {
    selectedImage = null;
    final image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = image;
    emit(PickImagesState());
  }

  void enableEdit(UserModel user) {
    userNameCtrl.text = user.name;
    bioCtrl.text = user.bio;
    imgUrl = user.imgUrl;
    emit(EnableEditState());
  }

  //upload image
  Future<String> _uploadImage(File file) async {
    return _storage
        .ref()
        .child('posts/${file.path}')
        .putFile(file)
        .then((snapshot) async {
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    });
  }
}

abstract class SettingsStates {}

class InitialSettingsState extends SettingsStates {}

class PickImagesState extends SettingsStates {}

class EnableEditState extends SettingsStates {}

class EditUserDataLoadingState extends SettingsStates {}

class EditUserDataSuccessState extends SettingsStates {}

class EditUserDataErrorState extends SettingsStates {}
