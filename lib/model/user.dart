import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String bio;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String imgUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.imgUrl,
    required this.bio,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      id: json['uid'],
      email: json['email'],
      name: json['username'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      imgUrl: json['imgUrl'],
      bio: json['bio'] ?? "bio...",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': id,
      'email': email,
      'username': name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'imgUrl': imgUrl,
      'bio': bio,
    };
  }
}
