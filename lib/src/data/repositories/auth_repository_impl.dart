//Concrete implementation
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lumiere/src/data/datasources/auth_remote_datasource.dart';
import 'package:lumiere/src/domain/errors/failure.dart';
import 'package:lumiere/src/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

import '../../domain/errors/failures/auth_failure.dart';
import '../../domain/errors/failures/server_failure.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _authRemoteDatasource;

  AuthRepositoryImpl({required AuthRemoteDatasource authRemoteDatasource})
      : _authRemoteDatasource = authRemoteDatasource;

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {

      User user = await _authRemoteDatasource.signInWithGoogle();
      return Right(user);

    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? "Auth error"));
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? "Server error"));
    } catch (e) {
      return Left(ServerFailure("Unexpected error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword(String email, String password) async {
    try {

      User user = await _authRemoteDatasource.signInWithEmailAndPassword(email, password);
      return Right(user);

    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? "Auth error"));
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? "Server error"));
    } catch (e) {
      return Left(ServerFailure("Unexpected error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword(String email, String password) async {
    try {

      User user = await _authRemoteDatasource.signUpWithEmailAndPassword(email, password);
      return Right(user);

    }on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? "Auth error"));
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? "Server error"));
    } catch (e) {
      return Left(ServerFailure("Unexpected error: ${e.toString()}"));
    }
  }

  @override
  Future<void> signOut() async {
    await _authRemoteDatasource.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authRemoteDatasource.sendPasswordResetEmail(email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {

      User user = await _authRemoteDatasource.currentUser();
      return Right(user);

    }on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? "Auth error"));
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? "Server error"));
    } catch (e) {
      return Left(ServerFailure("Unexpected error: ${e.toString()}"));
    }
  }
}