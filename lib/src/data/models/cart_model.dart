import '../../domain/entities/cart.dart';

class CartModel extends Cart {
  CartModel({
    required super.cart_id,
    required super.user_id,
  });

  CartModel copyWith({
    String? cart_id,
    String? user_id,
  }) {
    return CartModel(
      cart_id: cart_id ?? this.cart_id,
      user_id: user_id ?? this.user_id,
    );
  }
}