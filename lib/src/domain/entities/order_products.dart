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

  OrderProducts copyWith({
    String? order_product_id,
    String? order_id,
    String? product_id,
    double? sale_price,
    double? cost_price,
    int? quantity_ordered,
  }) {
    return OrderProducts(
      order_product_id: order_product_id ?? this.order_product_id,
      order_id: order_id ?? this.order_id,
      product_id: product_id ?? this.product_id,
      sale_price: sale_price ?? this.sale_price,
      cost_price: cost_price ?? this.cost_price,
      quantity_ordered: quantity_ordered ?? this.quantity_ordered,
    );
  }

  @override
  List<Object?> get props => [order_product_id, order_id, product_id, cost_price, sale_price, quantity_ordered];
}