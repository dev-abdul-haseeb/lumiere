import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.user_id,
    required super.email,
    required super.token,
    required super.first_name,
    required super.last_name,
    required super.phone_number,
    required super.is_admin,
  });

  UserModel copyWith({
    String? user_id,
    String? email,
    String? token,
    String? first_name,
    String? last_name,
    String? phone_number,
    bool? is_admin,
  }) {
    return UserModel(
      user_id: user_id ?? this.user_id,
      email: email ?? this.email,
      token: token ?? this.token,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      phone_number: phone_number ?? this.phone_number,
      is_admin: is_admin ?? this.is_admin,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      user_id: '',
      token: map['token'],
      email: map['email'],
      first_name: map['first_name'],
      last_name: map['last_name'],
      phone_number: map['phone_number'],
      is_admin: map['is_admin'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'email': email,
      'first_name': first_name,
      'last_name': last_name,
      'phone_number': phone_number,
      'is_admin': is_admin,
    };
  }

}