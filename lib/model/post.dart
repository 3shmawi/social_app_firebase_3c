import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_3c/model/user.dart';

class PostModel {
  final String postId;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String? postImageUrl;
  final String title;
  final UserModel user;
  final int editCount;

  PostModel({
    required this.postId,
    required this.createdAt,
    required this.updatedAt,
    this.postImageUrl,
    required this.title,
    required this.user,
    required this.editCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'postImageUrl': postImageUrl,
      'title': title,
      'editCount': editCount,
      'user': user.toJson(),
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> json) {
    return PostModel(
      postId: json['postId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      postImageUrl: json['postImageUrl'],
      title: json['title'],
      editCount: json['editCount'],
      user: UserModel.fromMap(json['user']),
    );
  }
}
