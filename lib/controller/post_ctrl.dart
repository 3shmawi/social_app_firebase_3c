import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_3c/model/post.dart';
import 'package:social_3c/model/user.dart';
import 'package:social_3c/screens/_resources/shared/toast.dart';

class PostCtrl extends Cubit<PostStates> {
  PostCtrl() : super(PostInitialState());

  final _fireStore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final contentCtrl = TextEditingController();
  final _picker = ImagePicker();

  XFile? selectedImage;
  String? imgUrl;

  void createOrEdit(UserModel user) {
    if (editedPost == null) {
      createPost(user);
    } else {
      editPost(user);
    }
  }

  void createPost(UserModel user) async {
    if (contentCtrl.text.isEmpty) {
      AppToast.error("Please enter content");
      return;
    }
    emit(CreatePostLoadingState());
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
        .doc(newId)
        .set(post.toJson())
        .then((value) {
      AppToast.success("Created post successfully");
      contentCtrl.clear();
      selectedImage = null;
      editedPost = null;
      imgUrl = null;
      getPost();
    }).catchError((error) {
      AppToast.error("Failed to create post. Please try again later.");
      emit(CreatePostErrorState());
    });
  }

  void editPost(UserModel user) async {
    if (contentCtrl.text.isEmpty) {
      AppToast.error("Please enter content");
      return;
    }
    emit(CreatePostLoadingState());
    if (selectedImage != null) {
      imgUrl = await _uploadImage(File(selectedImage!.path));
    }
    final post = PostModel(
      postId: editedPost!.postId,
      content: contentCtrl.text,
      createdAt: editedPost!.createdAt,
      updatedAt: Timestamp.now(),
      postImageUrl: imgUrl,
      user: user,
    );

    _fireStore
        .collection("beboPosts")
        .doc(post.postId)
        .update(post.toJson())
        .then((value) {
      AppToast.success("Updated post successfully");
      contentCtrl.clear();
      selectedImage = null;
      editedPost = null;
      imgUrl = null;
      getPost();
    }).catchError((error) {
      AppToast.error("Failed to update post. Please try again later.");
      emit(CreatePostErrorState());
    });
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
        .child('posts/${file.path}')
        .putFile(file)
        .then((snapshot) async {
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    });
  }

  List<PostModel> posts = [];

  void getPost() {
    emit(GetPostsLoadingState());
    _fireStore
        .collection("beboPosts")
        .orderBy("createdAt", descending: true)
        .get()
        .then((querySnapshot) {
      posts = querySnapshot.docs
          .map((doc) => PostModel.fromJson(doc.data()))
          .toList();
      emit(GetPostsSuccessState());
    }).catchError((error) {
      AppToast.error("Failed to get posts. Please try again later.");
      emit(GetPostsErrorState());
    });
  }

  Future<List<PostModel>> getMyPost(String userId) async {
    final response = await _fireStore
        .collection("beboPosts")
        .orderBy("createdAt", descending: true)
        .where("user.uid", isEqualTo: userId)
        .get();
    print(response.docs.length);
    return response.docs.map((doc) => PostModel.fromJson(doc.data())).toList();
  }

  Future<List<PostModel>> getMyPostPhotos(String userId) async {
    final response = await _fireStore
        .collection("beboPosts")
        .orderBy("createdAt", descending: true)
        .where("postImageUrl", isNotEqualTo: null)
        .where("user.uid", isEqualTo: userId)
        .get();
    return response.docs
        .map((doc) {
          return PostModel.fromJson(doc.data());
        })
        .toList()
        .where((post) => post.postImageUrl != null)
        .toList();
  }

  PostModel? editedPost;

  void enableEditPost(PostModel post) {
    editedPost = post;
    imgUrl = post.postImageUrl;
    contentCtrl.text = post.content;
    emit(EditPostState());
  }

  void deletePost(String postId) {
    _fireStore.collection("beboPosts").doc(postId).delete().then((value) {
      AppToast.success("Post deleted successfully");
      getPost();
    });
  }

  //search

  final searchCtrl = TextEditingController();
  List<PostModel> filteredPosts = [];

  void searchPosts() {
    filteredPosts = posts.where((post) {
      return post.content
              .toLowerCase()
              .contains(searchCtrl.text.toLowerCase()) ||
          post.user.name.toLowerCase().contains(searchCtrl.text.toLowerCase());
    }).toList();
    emit(GetPostsSuccessState());
  }
}

abstract class PostStates {}

class PostInitialState extends PostStates {}

final class CreatePostLoadingState extends PostStates {}

class CreatePostSuccessState extends PostStates {}

class CreatePostErrorState extends PostStates {}

final class GetPostsLoadingState extends PostStates {}

class GetPostsSuccessState extends PostStates {}

class GetPostsErrorState extends PostStates {}

class PickImagesState extends PostStates {}

class EditPostState extends PostStates {}
