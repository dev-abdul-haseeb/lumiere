import 'package:equatable/equatable.dart';

class CartItems extends Equatable   {
  final String cart_item_id;
  final String cart_id;
  final String product_id;
  final int quantity;
  CartItems ({
    required this.cart_item_id,
    required this.cart_id,
    required this.product_id,
    required this.quantity,
  });

  CartItems copyWith({
    String? cart_item_id,
    String? cart_id,
    String? product_id,
    int? quantity,
  }) {
    return CartItems(
      cart_item_id: cart_item_id ?? this.cart_item_id,
      cart_id: cart_id ?? this.cart_id,
      product_id: product_id ?? this.product_id,
      quantity: quantity ?? this.quantity,
    );
  }


  @override
  List<Object?> get props => [cart_item_id, cart_id, product_id, quantity];
}