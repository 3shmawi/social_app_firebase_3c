import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_3c/model/post.dart';
import 'package:social_3c/model/user.dart';

import '../screens/_resources/shared/toast.dart';

class PostsCtrl extends Cubit<PostsStates> {
  PostsCtrl() : super(PostInitialState());

  final _fireStore = FirebaseFirestore.instance;

  final titleCtrl = TextEditingController();
  XFile? image;
  final ImagePicker _picker = ImagePicker();

  void createPost(UserModel user) async {
    if (titleCtrl.text.isEmpty) {
      AppToast.error("Please enter a post content");
      return;
    }
    emit(UploadPostLoadingState());
    final newId = DateTime.now().toIso8601String();
    String? imageUrl;
    if (image != null) {
      imageUrl = await _uploadImageAndGetUrl(File(image!.path));
    }
    final postItem = PostModel(
      postId: newId,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      postImageUrl: imageUrl,
      title: titleCtrl.text,
      user: user,
    );

    _fireStore
        .collection("posts")
        .doc(newId)
        .set(postItem.toMap())
        .then((value) {
      AppToast.success("Crate post successfully");

      titleCtrl.clear();
      image = null;
      fetchPosts();
      emit(UploadPostSuccessState());
    }).catchError((error) {
      AppToast.error("Failed to create post");
      emit(UploadPostErrorState());
    });
  }

  Future<String> _uploadImageAndGetUrl(File file) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child("posts/${file.path}");
      final uploadTaskSnapshot = await storageRef.putFile(file);
      final url = await uploadTaskSnapshot.ref.getDownloadURL();
      return url.toString();
    } catch (error) {
      throw Exception("Error uploading image: $error");
    }
  }

  Future<void> pickImage() async {
    this.image = null;
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      this.image = image;
    }
    emit(PickImageState());
  }

  List<PostModel> posts = [];

  void fetchPosts() async {
    emit(GetPostLoadingState());
    try {
      final querySnapshot = await _fireStore.collection("posts").get();
      posts = querySnapshot.docs
          .map((doc) => PostModel.fromMap(doc.data()))
          .toList();
      emit(GetPostSuccessState());
    } on Exception {
      AppToast.error("Failed to fetch posts");
      emit(GetPostErrorState());
    }
  }
}

abstract class PostsStates {}

final class PostInitialState extends PostsStates {}

final class UploadPostLoadingState extends PostsStates {}

final class UploadPostSuccessState extends PostsStates {}

final class UploadPostErrorState extends PostsStates {}

final class PickImageState extends PostsStates {}

final class GetPostLoadingState extends PostsStates {}

final class GetPostSuccessState extends PostsStates {}

final class GetPostErrorState extends PostsStates {}
