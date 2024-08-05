import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_3c/model/user.dart';

class PostModel {
  final String postId;
  final String content;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final UserModel user;
  final String? postImageUrl;

  PostModel({
    required this.postId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    this.postImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'content': content,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'user': user.toJson(),
      'postImageUrl': postImageUrl,
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['postId'],
      content: json['content'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      user: UserModel.fromMap(json['user']),
      postImageUrl: json['postImageUrl'],
    );
  }
}
