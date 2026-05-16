// data/models/cart_items_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/cart_items.dart';

class CartItemsModel extends CartItems {
  CartItemsModel({
    required super.cart_item_id,
    required super.cart_id,
    required super.product_id,
    required super.quantity,
  });

  @override
  CartItemsModel copyWith({
    String? cart_item_id,
    String? cart_id,
    String? product_id,
    int? quantity,
  }) {
    return CartItemsModel(
      cart_item_id: cart_item_id ?? this.cart_item_id,
      cart_id:      cart_id      ?? this.cart_id,
      product_id:   product_id   ?? this.product_id,
      quantity:     quantity     ?? this.quantity,
    );
  }

  factory CartItemsModel.fromFirestore(Map<String, dynamic> map, {required String id}) {
    return CartItemsModel(
      cart_item_id: id,
      cart_id:      map['cart_id']    as String,
      product_id:   map['product_id'] as String,
      quantity:     map['quantity']   as int,
    );
  }

  Map<String, dynamic> toMap() => {
    'cart_id':    cart_id,
    'product_id': product_id,
    'quantity':   quantity,
    'addedAt':    FieldValue.serverTimestamp(),
  };
}