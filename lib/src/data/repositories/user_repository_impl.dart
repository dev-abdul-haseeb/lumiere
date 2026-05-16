

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:lumiere/src/data/models/user_model.dart';

import '../../domain/entities/user.dart';
import '../../domain/errors/failure.dart';
import '../../domain/errors/failures/auth_failure.dart';
import '../../domain/errors/failures/server_failure.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource _userRemoteDatasource;

  UserRepositoryImpl({
    required UserRemoteDatasource userRemoteDatasource,
  }) : _userRemoteDatasource = userRemoteDatasource;

  @override
  Future<Either<Failure, User>> createUserInDb(User user) async {
    try {
      final userModel = UserModel(
        user_id: user.user_id,
        email: user.email,
        token: user.token,
        first_name: user.first_name,
        last_name: user.last_name,
        phone_number: user.phone_number,
        is_admin: user.is_admin,
      );

      final createdModel =
      await _userRemoteDatasource.createUser(userModel);

      User new_user = User(
        user_id: createdModel.user_id,
        email: createdModel.email,
        token: createdModel.token,
        first_name: createdModel.first_name,
        last_name: createdModel.last_name,
        phone_number: createdModel.phone_number,
        is_admin: createdModel.is_admin,
      );
      return Right(new_user);

    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? "Auth error"));

    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? "Server error"));
    } catch (e) {
      return Left(ServerFailure("Unexpected error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, User>> getUserDataById(String uid) async {
    try {
      final userModel = await _userRemoteDatasource.getUserById(uid);

      User user = User(
        user_id: uid,
        email: userModel.email,
        token: userModel.token,
        first_name: userModel.first_name,
        last_name: userModel.last_name,
        phone_number: userModel.phone_number,
        is_admin: userModel.is_admin,
      );
      return Right(user);

    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? "User fetch failed"));

    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }

  }

  @override
  Future<Either<Failure, User>> updateUser(User user) async {
    try {
      final userModel = UserModel(
        user_id: user.user_id,
        email: user.email,
        token: user.token,
        first_name: user.first_name,
        last_name: user.last_name,
        phone_number: user.phone_number,
        is_admin: user.is_admin,
      );

      await _userRemoteDatasource.updateUser(userModel);

      return Right(user);

    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}