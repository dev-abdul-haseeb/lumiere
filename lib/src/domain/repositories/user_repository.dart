import 'package:dartz/dartz.dart';

import '../entities/user.dart';
import '../errors/failure.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> createUserInDb(User user);
  Future<Either<Failure, User>> getUserDataById(String uid);
  Future<Either<Failure, User>> updateUser(User user);
}