import 'package:equatable/equatable.dart';

class Cart extends Equatable   {
  final String cart_id;
  final String user_id;
  Cart ({
    required this.cart_id,
    required this.user_id,
  });

  Cart copyWith({
    String? cart_id,
    String? user_id,
  }) {
    return Cart(
      cart_id: cart_id ?? this.cart_id,
      user_id: user_id ?? this.user_id,
    );
  }


  @override
  List<Object?> get props => [cart_id, user_id];
}