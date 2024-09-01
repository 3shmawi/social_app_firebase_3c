import 'package:social_3c/model/user.dart';

class PostModel {
  final String postId;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserModel user;
  final String? postImgUrl;

  PostModel({
    required this.postId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    this.postImgUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'content': content,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'user': user.toJson(),
      'postImgUrl': postImgUrl,
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['postId'],
      content: json['content'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      user: UserModel.fromMap(json['user']),
      postImgUrl: json['postImgUrl'],
    );
  }
}
