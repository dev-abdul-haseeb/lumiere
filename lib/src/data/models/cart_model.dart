// data/models/cart_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/cart.dart';

class CartModel extends Cart {
  CartModel({
    required super.cart_id,
    required super.user_id,
  });

  @override
  CartModel copyWith({String? cart_id, String? user_id}) {
    return CartModel(
      cart_id: cart_id ?? this.cart_id,
      user_id: user_id ?? this.user_id,
    );
  }

  factory CartModel.fromFirestore(Map<String, dynamic> map, {required String id}) {
    return CartModel(
      cart_id: id,
      user_id: map['user_id'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
    'user_id': user_id,
    'createdAt': FieldValue.serverTimestamp(),
  };
}