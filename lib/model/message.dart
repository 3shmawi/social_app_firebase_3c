import 'package:social_3c/model/user.dart';

class MessageModel {
  final String id;
  final String message;
  final String createdAt;
  final bool isEdited;
  final UserModel sender;
  final UserModel receiver;

  MessageModel({
    required this.id,
    required this.message,
    required this.createdAt,
    this.isEdited = false,
    required this.sender,
    required this.receiver,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'createdAt': createdAt,
      'isEdited': isEdited,
      'sender': sender.toJson(),
      'receiver': receiver.toJson(),
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      message: json['message'],
      createdAt: json['createdAt'],
      isEdited: json['isEdited'] ?? false,
      sender: UserModel.fromMap(json['sender']),
      receiver: UserModel.fromMap(json['receiver']),
    );
  }
}
