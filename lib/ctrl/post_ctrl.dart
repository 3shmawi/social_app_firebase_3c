import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_3c/model/post.dart';
import 'package:social_3c/model/user.dart';

class PostCtrl extends Cubit<PostStates> {
  PostCtrl() : super(PostInitialState());

  final _database = FirebaseFirestore.instance;
  final _storage = FirebaseFirestore.instance;
  final _picker = ImagePicker();
  final contentCtrl = TextEditingController();
  String? imgUrl;
  PostModel? editedPost;
  XFile? selectedImage;

  void createOrEditPost() {}

  void _createPost(UserModel user) {
    final newId = DateTime.now().toIso8601String();

    if (selectedImage != null) {}
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
        .then((v) {})
        .catchError((error) {});
  }

  void _editPost() {}

  void fetchPosts() {}

  void deletePost() {}

  Future<void> pickImg() async {
    selectedImage = null;
    final image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = image;
    emit(PickImageState());
  }

  // Future<String> _uploadImgToFirebaseStorageAndGetDownloadUrl(File file) async {
  //   final storageRef = _storage
  //       .storage()
  //       .ref()
  //       .child('images/${selectedImage!.path.split('/').last!}');
  //   await storageRef.putFile(file);
  //   return storageRef.getDownloadURL();
  // }

  void clearSelectedImg() {
    selectedImage = null;
    imgUrl = null;
    emit(PickImageState());
  }

  void enableEditPost(PostModel post) {
    editedPost = post;
    emit(EditPostState());
  }
}

abstract class PostStates {}

class PostInitialState extends PostStates {}

class EditPostState extends PostStates {}

class PickImageState extends PostStates {}
