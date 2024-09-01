import 'package:social_3c/model/user.dart';

class MessageModel {
  final String messageId;
  final String message;
  final String date;
  final UserModel sender;
  final UserModel receiver;

  MessageModel({
    required this.messageId,
    required this.message,
    required this.date,
    required this.sender,
    required this.receiver,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': messageId,
      'message': message,
      'date': date,
      'sender': sender.toJson(),
      'receiver': receiver.toJson(),
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['id'],
      message: json['message'],
      date: json['date'],
      sender: UserModel.fromMap(json['sender']),
      receiver: UserModel.fromMap(json['receiver']),
    );
  }
}

class ChatModel {
  final UserModel receiver;
  final String lastMessage;
  final String date;
  final bool isOnline;
  final String lastSeen;

  ChatModel({
    required this.receiver,
    required this.lastMessage,
    required this.date,
    required this.isOnline,
    required this.lastSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'receiver': receiver.toJson(),
      'lastMessage': lastMessage,
      'date': date,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> json) {
    return ChatModel(
      receiver: UserModel.fromMap(json['receiver']),
      lastMessage: json['lastMessage'],
      date: json['date'],
      isOnline: json['isOnline'] ?? false,
      lastSeen: json['lastSeen'] ?? "now",
    );
  }
}
