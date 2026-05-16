import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:lumiere/src/domain/entities/application.dart';
import 'package:lumiere/src/domain/errors/failure.dart';
import 'package:lumiere/src/domain/repositories/application_repository.dart';
import '../../domain/errors/failures/server_failure.dart';
import '../datasources/application_remote_datasource.dart';
import '../models/application_model.dart';

class ApplicationRepositoryImpl extends ApplicationRepository {
  ApplicationRemoteDatasource _remoteDataSource = ApplicationRemoteDatasource();

  @override
  Future<Either<Failure, Application>> getApplicationData() async {
    try {
      final application = await _remoteDataSource.getApplicationData();
      return Right(application);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firebase error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Application>> updateApplicationData(Application application) async {
    try {
      final model = ApplicationModel(
        id: application.id,
        name: application.name,
        tagLine: application.tagLine,
        subTitle: application.subTitle,
        contact_email: application.contact_email,
        free_shipping_threshold: application.free_shipping_threshold,
        standard_shipping_rate: application.standard_shipping_rate,
        express_shipping_rate: application.express_shipping_rate,
      );
      final updated = await _remoteDataSource.updateApplicationData(model);
      return Right(updated);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firebase error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}