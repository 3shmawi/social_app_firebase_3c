import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_3c/model/user.dart';
import 'package:social_3c/screens/_resources/shared/toast.dart';

import '../model/post.dart';

class PostCtrl extends Cubit<PostStates> {
  PostCtrl() : super(PostInitialState());

  final _picker = ImagePicker();
  final _fireStore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final contentCtrl = TextEditingController();
  String? imgUrl;

  XFile? selectedMedia;

  void createOrEditPost(UserModel user) {
    if (post == null) {
      createPost(user);
    } else {
      editPost();
    }
  }

  void createPost(UserModel user) async {
    if (contentCtrl.text.isEmpty) {
      AppToast.error("You should write anything first");
      return;
    }
    emit(CreatePostLoadingState());

    if (selectedMedia != null) {
      imgUrl = await _uploadMediaToGetDownloadUrl(File(selectedMedia!.path));
    }
    final newId = DateTime.now().toIso8601String();
    final newPost = PostModel(
      postId: newId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      content: contentCtrl.text,
      user: user,
      mediaUrl: imgUrl,
    );

    _fireStore
        .collection("MYM_Posts")
        .doc(newId)
        .set(newPost.toMap())
        .then((value) {
      AppToast.success("Post created successfully");
      getPosts();
      contentCtrl.clear();
      selectedMedia = null;
      imgUrl = null;
    }).catchError((error) {
      AppToast.error("Error creating post: ${error.message}");
      emit(CreatePostErrorState());
    });
  }

  Future<String> _uploadMediaToGetDownloadUrl(File file) async {
    final storageRef = _storage.ref().child('media/${DateTime.now()}');
    final uploadTask = storageRef.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl.toString();
  }

  Future<void> pickMedia() async {
    selectedMedia = null;
    final image = await _picker.pickImage(source: ImageSource.gallery);
    selectedMedia = image;
    emit(PickMediaState());
  }

  void clearMedia() {
    selectedMedia = null;
    imgUrl = null;
    emit(PickMediaState());
  }

  List<PostModel> posts = [];

  void getPosts() {
    emit(GetPostsLoadingState());
    _fireStore
        .collection("MYM_Posts")
        .orderBy("createdAt", descending: true)
        .get()
        .then((querySnapshot) {
      posts = querySnapshot.docs
          .map((doc) => PostModel.fromMap(doc.data()))
          .toList();
      emit(GetPostsSuccessState());
    }).catchError((error) {
      AppToast.error("Error getting posts: ${error.message}");
      emit(GetPostsErrorState());
    });
  }

  //edit and delete
  void deletePost(String postId) async {
    emit(DeletePostLoadingState());
    _fireStore.collection("MYM_Posts").doc(postId).delete().then((value) {
      AppToast.success("Post deleted successfully");
      getPosts();
    }).catchError((error) {
      AppToast.error("Error deleting post: ${error.message}");
      emit(DeletePostErrorState());
    });
  }

  void editPost() async {
    if (contentCtrl.text.isEmpty) {
      AppToast.error("You should write anything first");
      return;
    }
    emit(CreatePostLoadingState());

    if (selectedMedia != null) {
      imgUrl = await _uploadMediaToGetDownloadUrl(File(selectedMedia!.path));
    }
    final updatedPost = PostModel(
      postId: post!.postId,
      createdAt: post!.createdAt,
      updatedAt: DateTime.now(),
      content: contentCtrl.text,
      user: post!.user,
      mediaUrl: imgUrl,
    );
    _fireStore
        .collection("MYM_Posts")
        .doc(post!.postId)
        .update(updatedPost.toMap())
        .then((value) {
          AppToast.success("Post updated successfully");
          getPosts();
          contentCtrl.clear();
          selectedMedia = null;
          imgUrl = null;
          post = null;
        })
        .catchError((error) {})
        .catchError((error) {
          AppToast.error("Error updating post: ${error.message}");
          emit(CreatePostErrorState());
        });
  }

  PostModel? post;

  void enableEdit(PostModel post) {
    this.post = post;
    contentCtrl.text = post.content;
    imgUrl = post.mediaUrl;
    emit(EditPostState());
  }

  void clearDate() {
    contentCtrl.clear();
    imgUrl = null;
    post = null;
    emit(EditPostState());
  }
}

abstract class PostStates {}

class PostInitialState extends PostStates {}

class CreatePostLoadingState extends PostStates {}

class CreatePostSuccessState extends PostStates {}

class CreatePostErrorState extends PostStates {}

class GetPostsLoadingState extends PostStates {}

class GetPostsSuccessState extends PostStates {}

class GetPostsErrorState extends PostStates {}

class PickMediaState extends PostStates {}

//
class DeletePostLoadingState extends PostStates {}

class DeletePostErrorState extends PostStates {}

//
class EditPostState extends PostStates {}
