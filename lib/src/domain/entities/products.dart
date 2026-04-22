import 'package:equatable/equatable.dart';

class Products extends Equatable {
  final String productId;
  final String productName;
  final String subtitle;
  final String description;
  final String category;
  final int volume;
  final int stock_quantity;
  final double cost_price;
  final double sale_price;
  final String image_id;

  const Products({
    required this.productId,
    required this.productName,
    required this.subtitle,
    required this.description,
    required this.category,
    required this.volume,
    required this.stock_quantity,
    required this.cost_price,
    required this.sale_price,
    required this.image_id,
  });

  @override
  List<Object?> get props => [
    productId,
    productName,
    subtitle,
    description,
    category,
    volume,
    stock_quantity,
    cost_price,
    sale_price,
    image_id,
  ];
}