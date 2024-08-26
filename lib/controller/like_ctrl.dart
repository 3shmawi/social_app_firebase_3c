import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_3c/model/user.dart';

class LikeCtrl {
  final _database = FirebaseFirestore.instance;

  void likeUnLike({
    required String postId,
    required bool isLiked,
    required UserModel user,
  }) async {
    if (isLiked) {
      await _database
          .collection("beboPosts")
          .doc(postId)
          .collection("likes")
          .doc(user.id)
          .delete();
    } else {
      await _database
          .collection("beboPosts")
          .doc(postId)
          .collection("likes")
          .doc(user.id)
          .set(user.toJson());
    }
  }

  Stream<List<UserModel>> getLikes(String postId) {
    return _database
        .collection("beboPosts")
        .doc(postId)
        .collection("likes")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(
              (doc) => UserModel.fromMap(
                doc.data(),
              ),
            )
            .toList());
  }
}
