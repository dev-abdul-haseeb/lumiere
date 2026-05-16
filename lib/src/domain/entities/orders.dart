import 'package:equatable/equatable.dart';
import 'package:lumiere/src/core/enum/enum.dart';

class Orders extends Equatable   {
  final String order_id;
  final String buyer_id;
  final String address_id;
  final DateTime dateTime;
  final orderStatus status;
  final double shipment_cost;
  Orders ({
    required this.order_id,
    required this.buyer_id,
    required this.address_id,
    required this.dateTime,
    required this.status,
    required this.shipment_cost,
  });

  Orders copyWith({
    String? order_id,
    String? buyer_id,
    String? address_id,
    DateTime? dateTime,
    orderStatus? status,
    double? shipment_cost,
  }) {
    return Orders(
      order_id: order_id ?? this.order_id,
      buyer_id: order_id ?? this.buyer_id,
      address_id: address_id ?? this.address_id,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      shipment_cost: shipment_cost ?? this.shipment_cost,
    );
  }


  @override
  List<Object?> get props => [order_id, buyer_id, address_id, dateTime, status, shipment_cost];
}