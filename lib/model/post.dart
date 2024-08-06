import 'package:social_3c/model/user.dart';

class PostModel {
  final String postId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String content;
  final String? mediaUrl;
  final UserModel user;

  PostModel({
    required this.postId,
    required this.createdAt,
    required this.updatedAt,
    required this.content,
    this.mediaUrl,
    required this.user,
  });

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
      'content': content,
      'mediaUrl': mediaUrl,
      'user': user.toJson(),
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> json) {
    return PostModel(
      postId: json['postId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      content: json['content'],
      mediaUrl: json['mediaUrl'],
      user: UserModel.fromMap(json['user']),
    );
  }
}
