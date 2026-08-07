import 'package:equatable/equatable.dart';

class UserResponse extends Equatable {
  final String token;
  final UserModel user;

  const UserResponse({
    required this.token,
    required this.user,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      token: json['accessToken'] as String,
      user: UserModel.fromJson(json['user']),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'accessToken': token,
  //     'user': user.toJson(),
  //   };
  // }

  @override
  List<Object?> get props => [token, user];
}

class UserModel extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    // String? role,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      // role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson(String pass) {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password' : pass,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, name, email, phone, createdAt];
}
