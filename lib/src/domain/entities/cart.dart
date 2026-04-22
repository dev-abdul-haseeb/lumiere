import 'package:equatable/equatable.dart';

class Cart extends Equatable   {
  final String cart_id;
  final String user_id;
  Cart ({
    required this.cart_id,
    required this.user_id,
  });

  @override
  List<Object?> get props => [cart_id, user_id];
}