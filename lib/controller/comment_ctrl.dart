import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_3c/model/post.dart';
import 'package:social_3c/model/user.dart';

import '../screens/_resources/shared/toast.dart';

class CommentsCtrl extends Cubit<CommentsStates> {
  CommentsCtrl() : super(CommentInitialState());

  final _fireStore = FirebaseFirestore.instance;

  final commentCtrl = TextEditingController();
  XFile? image;
  String? imageUrl;

  final _picker = ImagePicker();

  void newOrEditComment(String postId, UserModel user) {
    if (editedComment == null) {
      _createComment(postId, user);
    } else {
      _editComment(postId, user);
    }
  }

  void _createComment(String postId, UserModel user) async {
    if (commentCtrl.text.isEmpty) {
      AppToast.error("Please enter a comment");
      return;
    }
    emit(UploadCommentLoadingState());
    final newId = DateTime.now().toIso8601String();
    String? imageUrl;
    if (image != null) {
      imageUrl = await _uploadImageAndGetUrl(File(image!.path));
    }
    final postItem = PostModel(
      postId: newId,
      editCount: 0,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      postImageUrl: imageUrl,
      title: commentCtrl.text,
      user: user,
    );

    _fireStore
        .collection("Patrick_posts")
        .doc(postId)
        .collection("comments")
        .doc(newId)
        .set(postItem.toMap())
        .then((value) {
      AppToast.success("Crate post successfully");
      imageUrl = null;

      commentCtrl.clear();
      image = null;
      fetchComments(postId);
    }).catchError((error) {
      AppToast.error("Failed to create comment");
      emit(UploadCommentErrorState());
    });
  }

  void _editComment(String postId, UserModel user) async {
    if (editedComment!.editCount > 3) {
      AppToast.error("You can't edit this post anymore");
      return;
    }
    if (commentCtrl.text.isEmpty) {
      AppToast.error("Please enter a post content");
      return;
    }
    emit(UploadCommentLoadingState());
    if (image != null) {
      imageUrl = await _uploadImageAndGetUrl(File(image!.path));
    }
    final postItem = PostModel(
      postId: editedComment!.postId,
      createdAt: editedComment!.createdAt,
      editCount: editedComment!.editCount + 1,
      updatedAt: Timestamp.now(),
      postImageUrl: imageUrl,
      title: commentCtrl.text,
      user: user,
    );

    _fireStore
        .collection("Patrick_posts")
        .doc(postId)
        .collection("comments")
        .doc(editedComment!.postId)
        .update(postItem.toMap())
        .then((value) {
      AppToast.success("Update comment successfully");

      editedComment = null;
      imageUrl = null;
      commentCtrl.clear();
      image = null;
      fetchComments(postId);
    }).catchError((error) {
      AppToast.error("Failed to create post");
      emit(UploadCommentErrorState());
    });
  }

  Future<String> _uploadImageAndGetUrl(File file) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child("comments/${file.path}");
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

  List<PostModel> comments = [];

  void fetchComments(String postId) async {
    emit(GetCommentLoadingState());
    try {
      final querySnapshot = await _fireStore
          .collection("Patrick_posts")
          .doc(postId)
          .collection("comments")
          .orderBy(
            "updatedAt",
            descending: true,
          )
          .get();
      comments = querySnapshot.docs
          .map((doc) => PostModel.fromMap(doc.data()))
          .toList();
      emit(GetCommentSuccessState());
    } on Exception {
      AppToast.error("Failed to fetch posts");
      emit(GetCommentErrorState());
    }
  }

  void deleteComment(String postId, String commentId) {
    _fireStore
        .collection("Patrick_posts")
        .doc(postId)
        .collection("comments")
        .doc(commentId)
        .delete()
        .then((value) {
      AppToast.success("Comment deleted successfully");
      fetchComments(postId);
    }).catchError((error) {
      AppToast.error("Failed to delete post");
    });
  }

  PostModel? editedComment;

  void editComment(PostModel post) {
    editedComment = post;
    commentCtrl.text = post.title;
    imageUrl = post.postImageUrl;
    emit(EditCommentState());
  }
}

abstract class CommentsStates {}

final class CommentInitialState extends CommentsStates {}

final class UploadCommentLoadingState extends CommentsStates {}

final class UploadCommentSuccessState extends CommentsStates {}

final class UploadCommentErrorState extends CommentsStates {}

final class PickImageState extends CommentsStates {}

final class GetCommentLoadingState extends CommentsStates {}

final class GetCommentSuccessState extends CommentsStates {}

final class GetCommentErrorState extends CommentsStates {}

final class EditCommentState extends CommentsStates {}
