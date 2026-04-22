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

  @override
  List<Object?> get props => [user_id, email, token, first_name, last_name,phone_number, is_admin];
}