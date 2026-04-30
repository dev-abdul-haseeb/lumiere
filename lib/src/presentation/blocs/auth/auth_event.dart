part of 'auth_bloc.dart';

abstract class AuthEvent {}

class IsLoggedIn extends AuthEvent {}

class SignInWithGmailRequested extends AuthEvent {}

class SignInWithPasswordRequested extends AuthEvent {
  final String email;
  final String password;

  SignInWithPasswordRequested({
    required this.email,
    required this.password,
  });
}

class SignUpWithPasswordRequested extends AuthEvent {
  final String token;
  final String email;
  final bool is_admin;
  final String password;

  SignUpWithPasswordRequested({
    this.token = '',
    this.email = '',
    this.is_admin = false,
    this.password = '',
  });
}

class UpdateUserDataRequested extends AuthEvent {
  final User user;
  final String first_name;
  final String last_name;
  final String phone_number;

  UpdateUserDataRequested({
    required this.user,
    required this.first_name,
    required this.last_name,
    required this.phone_number,
  });
}

class ForgetPasswordRequested extends AuthEvent {
  String email;
  ForgetPasswordRequested({
    required this.email
  });
}

class AuthLogOut extends AuthEvent {}