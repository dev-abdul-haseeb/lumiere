import 'package:lumiere/src/domain/entities/products.dart';

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
    required super.image_link,
    super.isNewArrival = false,
    super.isFeatured   = false,
  });

  @override
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
    String? image_link,
    bool? isNewArrival,
    bool? isFeatured,
  }) {
    return ProductsModel(
      productId:      productId      ?? this.productId,
      productName:    productName    ?? this.productName,
      subtitle:       subtitle       ?? this.subtitle,
      description:    description    ?? this.description,
      category:       category       ?? this.category,
      volume:         volume         ?? this.volume,
      stock_quantity: stock_quantity ?? this.stock_quantity,
      cost_price:     cost_price     ?? this.cost_price,
      sale_price:     sale_price     ?? this.sale_price,
      image_link:     image_link     ?? this.image_link,
      isNewArrival:   isNewArrival   ?? this.isNewArrival,
      isFeatured:     isFeatured     ?? this.isFeatured,
    );
  }

  factory ProductsModel.fromFirestore(Map<String, dynamic> map, {required String id}) {
    return ProductsModel(
      productId:      id,  // ← from doc.id, not the map
      productName:    map['productName'] as String,
      subtitle:       map['subtitle'] as String,
      description:    map['description'] as String,
      category:       map['category'] as String,
      volume:         map['volume'] as int,
      stock_quantity: map['stock_quantity'] as int,
      cost_price:     (map['cost_price'] as num).toDouble(),
      sale_price:     (map['sale_price'] as num).toDouble(),
      image_link:     map['image_link'] as String,
      isNewArrival:   map['isNewArrival'] as bool? ?? false,
      isFeatured:     map['isFeatured'] as bool? ?? false,
    );
  }
}