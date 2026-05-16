import 'package:dartz/dartz.dart';
import 'package:lumiere/src/domain/entities/application.dart';
import '../errors/failure.dart';

abstract class ApplicationRepository {
  Future<Either<Failure, Application>> getApplicationData();
  Future<Either<Failure, Application>> updateApplicationData(Application application);
}