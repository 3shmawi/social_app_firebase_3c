import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_3c/model/post.dart';
import 'package:social_3c/model/user.dart';
import 'package:social_3c/screens/_resourses/toast.dart';

class PostCtrl extends Cubit<PostStates> {
  PostCtrl() : super(PostInitialState());

  final _database = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _picker = ImagePicker();
  final contentCtrl = TextEditingController();
  String? imgUrl;
  PostModel? editedPost;
  XFile? selectedImage;

  void createOrEditPost(UserModel user) {
    if (editedPost == null) {
      _createPost(user);
    } else {
      _editPost(user);
    }
  }

  void _createPost(UserModel user) async {
    emit(PostLoadingState());
    final newId = DateTime.now().toIso8601String();

    if (selectedImage != null) {
      imgUrl = await _uploadImg(File(selectedImage!.path));
    }
    final newPost = PostModel(
      postId: newId,
      content: contentCtrl.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      user: user,
      postImgUrl: imgUrl,
    );

    _database
        .collection("Mohamed_Posts")
        .doc(newId)
        .set(newPost.toJson())
        .then((v) {
      AppToast.success("Created new post successfully");
      refresh();
    }).catchError((error) {
      emit(PostErrorState());
    });
  }

  void _editPost(UserModel user) async {
    emit(PostLoadingState());

    if (selectedImage != null) {
      imgUrl = await _uploadImg(File(selectedImage!.path));
    }
    final newPost = PostModel(
      postId: editedPost!.postId,
      content: contentCtrl.text,
      createdAt: editedPost!.createdAt,
      updatedAt: DateTime.now(),
      user: user,
      postImgUrl: imgUrl,
    );

    _database
        .collection("Mohamed_Posts")
        .doc(newPost.postId)
        .update(newPost.toJson())
        .then((v) {
      AppToast.success("Edited the post successfully");

      refresh();
    }).catchError((error) {
      emit(PostErrorState());
    });
  }

  List<PostModel> posts = [];

  void refresh() {
    posts = [];
    fetchPosts();
  }

  void fetchPosts() {
    if (posts.isNotEmpty) {
      return;
    }
    emit(PostLoadingState());
    _database.collection("Mohamed_Posts").get().then((v) {
      posts.clear();
      for (var doc in v.docs) {
        posts.add(PostModel.fromJson(doc.data()));
      }
      emit(PostSuccessState());
    }).catchError((error) {});
  }

  void deletePost(String postId) {
    _database.collection("Mohamed_Posts").doc(postId).delete().then((v) {
      AppToast.success("Deleted the post successfully");
      refresh();
    });
  }

  Future<void> pickImg() async {
    selectedImage = null;
    final image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = image;
    emit(PickImageState());
  }

  Future<String> _uploadImg(File file) async {
    final ref = _storage.ref().child('images/${file.path}');
    final task = ref.putFile(file);

    final snapshot = await task.whenComplete(() => {});
    final downloadUrl = snapshot.ref.getDownloadURL();
    return downloadUrl.toString();
  }

  void clearSelectedImg() {
    selectedImage = null;
    imgUrl = null;
    emit(PickImageState());
  }

  void enableEditPost(PostModel post) {
    editedPost = post;
    contentCtrl.text = post.content;
    imgUrl = post.postImgUrl;
    emit(EditPostState());
  }
}

abstract class PostStates {}

class PostInitialState extends PostStates {}

class EditPostState extends PostStates {}

class PickImageState extends PostStates {}

class PostLoadingState extends PostStates {}

class PostErrorState extends PostStates {}

class PostSuccessState extends PostStates {}
