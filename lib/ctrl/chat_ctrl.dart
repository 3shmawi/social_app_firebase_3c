import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_3c/model/chat.dart';
import 'package:social_3c/services/local_database.dart';

class ChatCtrl {
  final _database = FirebaseFirestore.instance;

  Stream<List<ChatModel>> getMyUsers() {
    return _database
        .collection("Mohamed_Users")
        .doc(myId)
        .collection("users")
        .orderBy("date", descending: true)
        .snapshots()
        .map((response) => response.docs
            .map((doc) => ChatModel.fromJson(doc.data()))
            .toList());
  }

  final myId = CacheHelper.getData(key: "myId");

  void changeTypingState(bool state) async {
    await _database
        .collection("Mohamed_Users")
        .doc(myId)
        .collection("users")
        .doc(myId)
        .update({"is_user_typing": state});
  }

  void changeReadingState() async {
    await _database
        .collection("Mohamed_Users")
        .doc(myId)
        .collection("users")
        .doc(myId)
        .update({"is_unread": false});
  }

  void changeActiveState(String state) async {
    await _database
        .collection("Mohamed_Users")
        .doc(myId)
        .collection("users")
        .doc(myId)
        .update({"is_active": state});
  }

  void changeLastSeeingState() async {
    await _database
        .collection("Mohamed_Users")
        .doc(myId)
        .collection("users")
        .doc(myId)
        .update({"last_seen": DateTime.now().toIso8601String()});
  }
}
