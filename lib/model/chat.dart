import 'package:social_3c/model/user.dart';

class MessageModel {
  final String message;
  final UserModel sender;
  final UserModel receiver;
  final String date;
  final String messageId;

  MessageModel({
    required this.message,
    required this.sender,
    required this.receiver,
    required this.date,
    required this.messageId,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'sender': sender.toJson(),
      'receiver': receiver.toJson(),
      'date': date,
      'messageId': messageId,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      message: map['message'],
      sender: UserModel.fromMap(map['sender']),
      receiver: UserModel.fromMap(map['receiver']),
      date: map['date'],
      messageId: map['messageId'],
    );
  }
}

class ChatModel {
  final UserModel receiver;
  final String lastMessage;
  final String date;

  ChatModel({
    required this.receiver,
    required this.lastMessage,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'receiver': receiver.toJson(),
      'lastMessage': lastMessage,
      'date': date,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      receiver: UserModel.fromMap(map['receiver']),
      lastMessage: map['lastMessage'],
      date: map['date'],
    );
  }
}
