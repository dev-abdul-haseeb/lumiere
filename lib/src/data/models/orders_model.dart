

import 'package:lumiere/src/core/enum/enum.dart';

import '../../domain/entities/orders.dart';

class OrdersModel extends Orders {
  OrdersModel({
    required super.order_id,
    required super.buyer_id,
    required super.address_id,
    required super.dateTime,
    required super.status,
    required super.shipment_cost,
  });

  OrdersModel copyWith({
    String? order_id,
    String? buyer_id,
    String? address_id,
    DateTime? dateTime,
    orderStatus? status,
    double? shipment_cost,
  }) {
    return OrdersModel(
      order_id: order_id ?? this.order_id,
      buyer_id: order_id ?? this.buyer_id,
      address_id: address_id ?? this.address_id,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      shipment_cost: shipment_cost ?? this.shipment_cost,
    );
  }
}