import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_3c/model/user.dart';

class LikeCtrl {
  final _database = FirebaseFirestore.instance;

  void like({
    required String postId,
    required UserModel myData,
    required bool isLiked,
  }) async {
    if (isLiked) {
      await _database
          .collection("posts")
          .doc(postId)
          .collection("likes")
          .doc(myData.id)
          .delete();
    } else {
      await _database
          .collection("posts")
          .doc(postId)
          .collection("likes")
          .doc(myData.id)
          .set(myData.toJson());
    }
  }

  Stream<List<UserModel>> likes(String postId) {
    return _database
        .collection("posts")
        .doc(postId)
        .collection("likes")
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList())
        .asBroadcastStream();
  }
}
