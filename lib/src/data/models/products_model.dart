import '../../domain/entities/products.dart';

class ProductsModel extends Products {
  const ProductsModel({
    required super.productId,
    required super.productName,
    required super.subtitle,
    required super.description,
    required super.category,
    required super.volume,
    required super.stock_quantity,
    required super.cost_price,
    required super.sale_price,
    required super.image_id,
  });


  ProductsModel copyWith({
    String? productId,
    String? productName,
    String? subtitle,
    String? description,
    String? category,
    int? volume,
    int? stock_quantity,
    double? cost_price,
    double? sale_price,
    String? image_id,
  }) {
    return ProductsModel(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      category: category ?? this.category,
      volume: volume ?? this.volume,
      stock_quantity: stock_quantity ?? this.stock_quantity,
      cost_price: cost_price ?? this.cost_price,
      sale_price: sale_price ?? this.sale_price,
      image_id: image_id ?? this.image_id,
    );
  }
}