// presentation/blocs/cart/cart_state.dart
part of 'cart_bloc.dart';

class CartState extends Equatable {
  final String?          cartId;
  final List<CartItems>  items;
  final bool             isLoading;
  final String?          error;

  const CartState({
    this.cartId,
    this.items    = const [],
    this.isLoading = false,
    this.error,
  });

  int get totalItems => items.fold(0, (sum, i) => sum + i.quantity);

  CartState copyWith({
    String?         cartId,
    List<CartItems>? items,
    bool?           isLoading,
    String?         error,
  }) {
    return CartState(
      cartId:    cartId    ?? this.cartId,
      items:     items     ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error:     error,
    );
  }

  @override
  List<Object?> get props => [cartId, items, isLoading, error];
}