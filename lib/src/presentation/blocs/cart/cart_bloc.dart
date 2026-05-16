// presentation/blocs/cart/cart_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lumiere/src/domain/entities/cart_items.dart';
import 'package:lumiere/src/domain/repositories/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _repository;

  CartBloc({required CartRepository repository})
      : _repository = repository,
        super(const CartState()) {
    on<LoadCartRequested>(_onLoad);
    on<AddToCartRequested>(_onAdd);
    on<RemoveFromCartRequested>(_onRemove);
    on<UpdateCartQuantityRequested>(_onUpdateQty);
    on<ClearCartRequested>(_onClear);
  }

  Future<void> _onLoad(LoadCartRequested event, Emitter<CartState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final cart  = await _repository.getOrCreateCart(event.userId);
      final items = await _repository.fetchCartItems(cart.cart_id);
      emit(state.copyWith(cartId: cart.cart_id, items: items, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onAdd(AddToCartRequested event, Emitter<CartState> emit) async {
    if (state.cartId == null) return;
    emit(state.copyWith(isLoading: true));
    try {
      await _repository.addItem(
        cartId:    state.cartId!,
        productId: event.productId,
        quantity:  event.quantity,
      );
      final items = await _repository.fetchCartItems(state.cartId!);
      emit(state.copyWith(items: items, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onRemove(RemoveFromCartRequested event, Emitter<CartState> emit) async {
    if (state.cartId == null) return;
    emit(state.copyWith(isLoading: true));
    try {
      await _repository.removeItem(event.cartItemId);
      final items = await _repository.fetchCartItems(state.cartId!);
      emit(state.copyWith(items: items, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onUpdateQty(UpdateCartQuantityRequested event, Emitter<CartState> emit) async {
    if (state.cartId == null) return;
    emit(state.copyWith(isLoading: true));
    try {
      await _repository.updateQuantity(
        cartItemId: event.cartItemId,
        quantity:   event.quantity,
      );
      final items = await _repository.fetchCartItems(state.cartId!);
      emit(state.copyWith(items: items, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onClear(ClearCartRequested event, Emitter<CartState> emit) async {
    if (state.cartId == null) return;
    emit(state.copyWith(isLoading: true));
    try {
      await _repository.clearCart(state.cartId!);
      emit(state.copyWith(items: [], isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}