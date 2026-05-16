// presentation/blocs/cart/cart_event.dart
part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCartRequested extends CartEvent {
  final String userId;
  LoadCartRequested({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}

class AddToCartRequested extends CartEvent {
  final String productId;
  final int    quantity;
  AddToCartRequested({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];
}

class RemoveFromCartRequested extends CartEvent {
  final String cartItemId;
  RemoveFromCartRequested({required this.cartItemId});

  @override
  List<Object?> get props => [cartItemId];
}

class UpdateCartQuantityRequested extends CartEvent {
  final String cartItemId;
  final int    quantity;
  UpdateCartQuantityRequested({required this.cartItemId, required this.quantity});

  @override
  List<Object?> get props => [cartItemId, quantity];
}

class ClearCartRequested extends CartEvent {}