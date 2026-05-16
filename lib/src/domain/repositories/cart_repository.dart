// domain/repositories/cart_repository.dart
import 'package:lumiere/src/domain/entities/cart.dart';
import 'package:lumiere/src/domain/entities/cart_items.dart';

abstract class CartRepository {
  Future<Cart>            getOrCreateCart(String userId);
  Future<List<CartItems>> fetchCartItems(String cartId);
  Future<void>            addItem({required String cartId, required String productId, required int quantity});
  Future<void>            removeItem(String cartItemId);
  Future<void>            updateQuantity({required String cartItemId, required int quantity});
  Future<void>            clearCart(String cartId);
}