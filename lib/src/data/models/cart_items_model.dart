import '../../domain/entities/cart_items.dart';

class CartItemsModel extends CartItems {
  CartItemsModel({
    required super.cart_item_id,
    required super.cart_id,
    required super.product_id,
    required super.quantity,
  });

  CartItemsModel copyWith({
    String? cart_item_id,
    String? cart_id,
    String? product_id,
    int? quantity,
  }) {
    return CartItemsModel(
      cart_item_id: cart_item_id ?? this.cart_item_id,
      cart_id: cart_id ?? this.cart_id,
      product_id: product_id ?? this.product_id,
      quantity: quantity ?? this.quantity,
    );
  }
}