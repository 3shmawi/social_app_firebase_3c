import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_3c/model/post.dart';
import 'package:social_3c/model/user.dart';
import 'package:social_3c/screens/_resources/shared/toast.dart';

class CommentCtrl extends Cubit<CommentStates> {
  CommentCtrl() : super(CommentInitialState());

  final _fireStore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final contentCtrl = TextEditingController();
  final _picker = ImagePicker();

  XFile? selectedImage;
  String? imgUrl;

  void createOrEdit({
    required String postId,
    required UserModel user,
  }) {
    if (editedComment == null) {
      createComment(postId, user);
    } else {
      editComment(postId, user);
    }
  }

  void createComment(String postId, UserModel user) async {
    if (contentCtrl.text.isEmpty) {
      AppToast.error("Please enter comment");
      return;
    }
    emit(CreateCommentLoadingState());
    final newId = DateTime.now().toIso8601String();
    if (selectedImage != null) {
      imgUrl = await _uploadImage(File(selectedImage!.path));
    }
    final post = PostModel(
      postId: newId,
      content: contentCtrl.text,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      postImageUrl: imgUrl,
      user: user,
    );

    _fireStore
        .collection("beboPosts")
        .doc(postId)
        .collection("comments")
        .doc(newId)
        .set(post.toJson())
        .then((value) {
      AppToast.success("Created comment successfully");
      contentCtrl.clear();
      selectedImage = null;
      editedComment = null;
      imgUrl = null;
      getComment(postId);
    }).catchError((error) {
      AppToast.error("Failed to create comment. Please try again later.");
      emit(CreateCommentErrorState());
    });
  }

  void editComment(String postId, UserModel user) async {
    if (contentCtrl.text.isEmpty) {
      AppToast.error("Please enter content");
      return;
    }
    emit(CreateCommentLoadingState());
    if (selectedImage != null) {
      imgUrl = await _uploadImage(File(selectedImage!.path));
    }
    final post = PostModel(
      postId: editedComment!.postId,
      content: contentCtrl.text,
      createdAt: editedComment!.createdAt,
      updatedAt: Timestamp.now(),
      postImageUrl: imgUrl,
      user: user,
    );

    _fireStore
        .collection("beboPosts")
        .doc(postId)
        .collection("comments")
        .doc(post.postId)
        .update(post.toJson())
        .then((value) {
      AppToast.success("Updated comment successfully");
      contentCtrl.clear();
      selectedImage = null;
      editedComment = null;
      imgUrl = null;
      getComment(postId);
    }).catchError((error) {
      AppToast.error("Failed to update comment. Please try again later.");
      emit(CreateCommentErrorState());
    });
  }

  void clearSelectedImage() {
    selectedImage = null;
    imgUrl = null;
    emit(PickImagesState());
  }

  Future<void> pickImage() async {
    selectedImage = null;
    final image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = image;
    emit(PickImagesState());
  }

  //upload image
  Future<String> _uploadImage(File file) async {
    return _storage
        .ref()
        .child('posts/comments/${file.path}')
        .putFile(file)
        .then((snapshot) async {
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    });
  }

  List<PostModel> posts = [];

  void getComment(String postId) {
    emit(GetCommentsLoadingState());
    _fireStore
        .collection("beboPosts")
        .doc(postId)
        .collection("comments")
        .orderBy("createdAt", descending: true)
        .get()
        .then((querySnapshot) {
      posts = querySnapshot.docs
          .map((doc) => PostModel.fromJson(doc.data()))
          .toList();
      emit(GetCommentsSuccessState());
    }).catchError((error) {
      AppToast.error("Failed to get comments. Please try again later.");
      emit(GetCommentsErrorState());
    });
  }

  PostModel? editedComment;

  void enableEditComment(PostModel post) {
    editedComment = post;
    imgUrl = post.postImageUrl;
    contentCtrl.text = post.content;
    emit(EditCommentState());
  }

  void deleteComment(String postId, String commentId) {
    _fireStore
        .collection("beboPosts")
        .doc(postId)
        .collection("comments")
        .doc(commentId)
        .delete()
        .then((value) {
      AppToast.success("Comment deleted successfully");
      getComment(postId);
    });
  }
}

abstract class CommentStates {}

class CommentInitialState extends CommentStates {}

final class CreateCommentLoadingState extends CommentStates {}

class CreateCommentSuccessState extends CommentStates {}

class CreateCommentErrorState extends CommentStates {}

final class GetCommentsLoadingState extends CommentStates {}

class GetCommentsSuccessState extends CommentStates {}

class GetCommentsErrorState extends CommentStates {}

class PickImagesState extends CommentStates {}

class EditCommentState extends CommentStates {}
