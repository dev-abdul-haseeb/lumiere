//Abstract only
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lumiere/src/domain/errors/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, User>> signInWithEmailAndPassword(String email, String password);
  Future<Either<Failure, User>> signUpWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<Either<Failure, User>> getCurrentUser();
  Future<void> sendPasswordResetEmail(String email);
}