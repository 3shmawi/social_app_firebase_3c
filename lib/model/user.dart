class UserModel {
  final String userId;
  final String userName;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String profileImgUrl;

  UserModel({
    required this.userId,
    required this.userName,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.profileImgUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      userName: json['username'],
      email: json['email'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      profileImgUrl: json['profile_img_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': userName,
      'email': email,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'profile_img_url': profileImgUrl,
    };
  }

  UserModel copyWith({
    String? userName,
    DateTime? updatedAt,
    String? profileImgUrl,
  }) {
    return UserModel(
      userId: userId,
      email: email,
      createdAt: createdAt,
      userName: userName ?? this.userName,
      updatedAt: updatedAt ?? this.updatedAt,
      profileImgUrl: profileImgUrl ?? this.profileImgUrl,
    );
  }
}
