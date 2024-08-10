import 'package:social_3c/model/user.dart';

class MessageModel {
  final String messageId;
  final String message;
  final String dateTime;
  final UserModel sender;
  final UserModel receiver;

  MessageModel({
    required this.messageId,
    required this.message,
    required this.dateTime,
    required this.sender,
    required this.receiver,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': messageId,
      'message': message,
      'dateTime': dateTime,
      'sender': sender.toJson(),
      'receiver': receiver.toJson(),
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['id'],
      message: json['message'],
      dateTime: json['dateTime'],
      sender: UserModel.fromMap(json['sender']),
      receiver: UserModel.fromMap(json['receiver']),
    );
  }
}

class UserChatModel {
  final String lastMessage;
  final String lastMessageDateTime;
  final UserModel user;

  UserChatModel({
    required this.lastMessage,
    required this.lastMessageDateTime,
    required this.user,
  });

  Map<String, dynamic> toJson() {
    return {
      'lastMessage': lastMessage,
      'lastMessageDateTime': lastMessageDateTime,
      'user': user.toJson(),
    };
  }

  factory UserChatModel.fromJson(Map<String, dynamic> json) {
    return UserChatModel(
      lastMessage: json['lastMessage'],
      lastMessageDateTime: json['lastMessageDateTime'],
      user: UserModel.fromMap(json['user']),
    );
  }
}
