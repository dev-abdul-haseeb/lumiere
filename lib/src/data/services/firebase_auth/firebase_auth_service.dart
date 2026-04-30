import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<User> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Web uses Firebase's built-in Google provider directly
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');

        final UserCredential userCredential =
        await _auth.signInWithPopup(googleProvider);

        final user = userCredential.user;
        if (user == null) throw Exception("Sign-in failed");
        return user;

      } else {
        // Android / iOS
        final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
          scopeHint: ['email', 'profile'],
        );

        final GoogleSignInAuthentication googleAuth =
            googleUser.authentication;

        if (googleAuth.idToken == null) throw Exception("ID Token is null");

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        final userCredential = await _auth.signInWithCredential(credential);
        final user = userCredential.user;
        if (user == null) throw Exception("Sign-in failed");
        return user;
      }

    } on GoogleSignInException catch (e) {
      throw Exception("Google Sign-In error: ${e.code.name} — ${e.description}");
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }
  Future<User> signInEmailAndPassword(String email, String password) async {
    try {
      final credentials = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final user = credentials.user;
      if (user == null) {
        throw Exception("User is null");
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<User> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final credentials = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final user = credentials.user;
      if (user == null) {
        throw Exception("User creation failed");
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<User> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("No logged-in user");
    }
    return user;
  }
}