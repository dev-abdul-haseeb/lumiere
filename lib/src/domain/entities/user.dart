import 'package:equatable/equatable.dart';

class User extends Equatable   {
  final String user_id;
  final String email;
  final String token;
  final String first_name;
  final String last_name;
  final String phone_number;
  final bool is_admin;
  User ({
    required this.user_id,
    required this.email,
    required this.token,
    required this.first_name,
    required this.last_name,
    required this.phone_number,
    required this.is_admin,
  });

  User copyWith({
    String? user_id,
    String? email,
    String? token,
    String? first_name,
    String? last_name,
    String? phone_number,
    bool? is_admin,
  }) {
    return User(
      user_id: user_id ?? this.user_id,
      email: email ?? this.email,
      token: token ?? this.token,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      phone_number: phone_number ?? this.phone_number,
      is_admin: is_admin ?? this.is_admin,
    );
  }
  @override
  List<Object?> get props => [user_id, email, token, first_name, last_name,phone_number, is_admin];
}