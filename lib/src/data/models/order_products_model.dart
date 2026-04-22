
import '../../domain/entities/order_products.dart';

class OrderProductsModel extends OrderProducts {
  OrderProductsModel({
    required super.order_product_id,
    required super.order_id,
    required super.product_id,
    required super.sale_price,
    required super.cost_price,
    required super.quantity_ordered,
  });

  OrderProductsModel copyWith({
    String? order_product_id,
    String? order_id,
    String? product_id,
    double? sale_price,
    double? cost_price,
    int? quantity_ordered,
  }) {
    return OrderProductsModel(
      order_product_id: order_product_id ?? this.order_product_id,
      order_id: order_id ?? this.order_id,
      product_id: product_id ?? this.product_id,
      sale_price: sale_price ?? this.sale_price,
      cost_price: cost_price ?? this.cost_price,
      quantity_ordered: quantity_ordered ?? this.quantity_ordered,
    );
  }
}