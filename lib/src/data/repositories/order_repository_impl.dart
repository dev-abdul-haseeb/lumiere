import 'package:lumiere/src/data/datasources/order_remote_datasource.dart';
import 'package:lumiere/src/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDatasource _orderRemoteDatasource;

  OrderRepositoryImpl({required OrderRemoteDatasource orderRemoteDatasource})
      : _orderRemoteDatasource = orderRemoteDatasource;

}