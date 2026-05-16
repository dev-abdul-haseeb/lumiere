// data/repositories/cart_repository_impl.dart
import 'package:lumiere/src/data/datasources/cart_remote_datasource.dart';
import 'package:lumiere/src/domain/entities/cart.dart';
import 'package:lumiere/src/domain/entities/cart_items.dart';
import 'package:lumiere/src/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDatasource _cartRemoteDatasource;

  CartRepositoryImpl({required CartRemoteDatasource cartRemoteDatasource})
      : _cartRemoteDatasource = cartRemoteDatasource;

  @override
  Future<Cart> getOrCreateCart(String userId) =>
      _cartRemoteDatasource.getOrCreateCart(userId);

  @override
  Future<List<CartItems>> fetchCartItems(String cartId) =>
      _cartRemoteDatasource.fetchCartItems(cartId);

  @override
  Future<void> addItem({required String cartId, required String productId, required int quantity}) =>
      _cartRemoteDatasource.addItem(cartId: cartId, productId: productId, quantity: quantity);

  @override
  Future<void> removeItem(String cartItemId) =>
      _cartRemoteDatasource.removeItem(cartItemId);

  @override
  Future<void> updateQuantity({required String cartItemId, required int quantity}) =>
      _cartRemoteDatasource.updateQuantity(cartItemId: cartItemId, quantity: quantity);

  @override
  Future<void> clearCart(String cartId) =>
      _cartRemoteDatasource.clearCart(cartId);
}