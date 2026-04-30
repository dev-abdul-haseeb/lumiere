part of 'auth_bloc.dart';
abstract class AuthState {}

class AuthUnAuthenticated extends AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}