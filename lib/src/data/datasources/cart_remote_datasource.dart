// data/datasources/cart_remote_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lumiere/src/core/constants/constants.dart';
import 'package:lumiere/src/data/models/cart_items_model.dart';
import 'package:lumiere/src/data/models/cart_model.dart';
import 'package:uuid/uuid.dart';

class CartRemoteDatasource {
  final FirebaseFirestore _firestore;
  static const _carts      = AppConstants.cartCollection;
  static const _cartItems  = AppConstants.cartItemsCollection;
  final _uuid = const Uuid();

  CartRemoteDatasource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  // ── Get or create a cart for the user ──────────────────────────────────────

  Future<CartModel> getOrCreateCart(String userId) async {
    final existing = await _firestore
        .collection(_carts)
        .where('user_id', isEqualTo: userId)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      final doc = existing.docs.first;
      return CartModel.fromFirestore(doc.data(), id: doc.id);
    }

    // Create new cart
    final cartId  = _uuid.v4();
    final newCart = CartModel(cart_id: cartId, user_id: userId);
    await _firestore.collection(_carts).doc(cartId).set(newCart.toMap());
    return newCart;
  }

  // ── Fetch cart items ────────────────────────────────────────────────────────

  Future<List<CartItemsModel>> fetchCartItems(String cartId) async {
    final snapshot = await _firestore
        .collection(_cartItems)
        .where('cart_id', isEqualTo: cartId)
        .get();

    return snapshot.docs
        .map((doc) => CartItemsModel.fromFirestore(doc.data(), id: doc.id))
        .toList();
  }

  // ── Add item (or increment if already exists) ───────────────────────────────

  Future<void> addItem({required String cartId, required String productId, required int quantity}) async {
    final itemId = '${cartId}_$productId';
    final docRef = _firestore.collection(_cartItems).doc(itemId);
    final doc    = await docRef.get();

    if (doc.exists) {
      final currentQty = doc.data()!['quantity'] as int;
      await docRef.update({'quantity': currentQty + quantity});
    } else {
      await docRef.set(CartItemsModel(
        cart_item_id: itemId,
        cart_id:      cartId,
        product_id:   productId,
        quantity:     quantity,
      ).toMap());
    }
  }

  // ── Remove item entirely ────────────────────────────────────────────────────

  Future<void> removeItem(String cartItemId) async {
    await _firestore.collection(_cartItems).doc(cartItemId).delete();
  }

  // ── Update quantity ─────────────────────────────────────────────────────────

  Future<void> updateQuantity({
    required String cartItemId,
    required int quantity,
  }) async {
    if (quantity <= 0) {
      await removeItem(cartItemId);
    } else {
      await _firestore
          .collection(_cartItems)
          .doc(cartItemId)
          .update({'quantity': quantity});
    }
  }

  // ── Clear entire cart ───────────────────────────────────────────────────────

  Future<void> clearCart(String cartId) async {
    final snapshot = await _firestore
        .collection(_cartItems)
        .where('cart_id', isEqualTo: cartId)
        .get();

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}