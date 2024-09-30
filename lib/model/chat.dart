import 'package:social_3c/model/user.dart';

class ChatModel {
  final UserModel user;
  final String lastMessage;
  final bool isUserTyping;
  final String date;
  final bool isUnread;
  final bool isActive;
  final String lastSeen;

  ChatModel({
    required this.user,
    required this.lastMessage,
    this.isUserTyping = false,
    required this.date,
    this.isUnread = false,
    this.isActive = false,
    this.lastSeen = '',
  });

  ChatModel copyWith({
    UserModel? user,
    String? lastMessage,
    bool? isUserTyping,
    String? date,
    bool? isUnread,
    bool? isActive,
    String? lastSeen,
  }) {
    return ChatModel(
      user: user ?? this.user,
      lastMessage: lastMessage ?? this.lastMessage,
      isUserTyping: isUserTyping ?? this.isUserTyping,
      date: date ?? this.date,
      isUnread: isUnread ?? this.isUnread,
      isActive: isActive ?? this.isActive,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      user: UserModel.fromMap(json['user']),
      lastMessage: json['last_message'],
      isUserTyping: json['is_user_typing'] == true,
      date: json['date'],
      isUnread: json['is_unread'] == true,
      isActive: json['is_active'] == true,
      lastSeen: json['last_seen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'last_message': lastMessage,
      'is_user_typing': isUserTyping,
      'date': date,
      'is_unread': isUnread,
      'is_active': isActive,
      'last_seen': lastSeen,
    };
  }
}
