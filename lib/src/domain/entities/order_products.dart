import 'package:equatable/equatable.dart';

class OrderProducts extends Equatable   {
  final String order_product_id;
  final String order_id;
  final String product_id;
  final double cost_price;
  final double sale_price;
  final int quantity_ordered;
  OrderProducts ({
    required this.order_product_id,
    required this.order_id,
    required this.product_id,
    required this.cost_price,
    required this.sale_price,
    required this.quantity_ordered,
  });

  @override
  List<Object?> get props => [order_product_id, order_id, product_id, cost_price, sale_price, quantity_ordered];
}