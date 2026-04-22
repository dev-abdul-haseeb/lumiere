import 'package:equatable/equatable.dart';
import 'package:lumiere/src/core/enum/enum.dart';

class Orders extends Equatable   {
  final String order_id;
  final String buyer_id;
  final String address_id;
  final DateTime dateTime;
  final orderStatus status;
  Orders ({
    required this.order_id,
    required this.buyer_id,
    required this.address_id,
    required this.dateTime,
    required this.status,
  });

  @override
  List<Object?> get props => [order_id, buyer_id, address_id, dateTime, status];
}