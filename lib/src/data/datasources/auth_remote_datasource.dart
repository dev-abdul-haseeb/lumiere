import 'package:firebase_auth/firebase_auth.dart';
import 'package:lumiere/src/data/services/firebase_auth/firebase_auth_service.dart';

class AuthRemoteDatasource {
  final FirebaseAuthService _authService = FirebaseAuthService();

  Future<User> signInWithGoogle() async {
   return await _authService.signInWithGoogle();
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    return await _authService.signInEmailAndPassword(email, password);
  }

  Future<User> signUpWithEmailAndPassword(String email, String password) async {
    return await _authService.signUpWithEmailAndPassword(email, password);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }

  Future<void> signOut() async {
    return await _authService.signOut();
  }

  Future<User> currentUser() async {
    return await _authService.getCurrentUser();
  }
}