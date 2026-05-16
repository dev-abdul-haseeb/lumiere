import 'package:lumiere/src/data/datasources/review_remote_datasource.dart';
import 'package:lumiere/src/domain/repositories/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDatasource _remoteDatasource;

  ReviewRepositoryImpl({required ReviewRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

}