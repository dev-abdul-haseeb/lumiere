part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class AddProductRequested extends ProductEvent {
  final String  name;
  final String  subtitle;
  final double  costPrice;
  final double  salePrice;
  final int     volume;
  final String  category;
  final int     stock;
  final String  description;
  final bool    isNewArrival;
  final bool    isFeatured;
  final String? imagePath;

  const AddProductRequested({
    required this.name,
    required this.subtitle,
    required this.costPrice,
    required this.salePrice,
    required this.volume,
    required this.category,
    required this.stock,
    required this.description,
    required this.isNewArrival,
    required this.isFeatured,
    this.imagePath,
  });

  @override
  List<Object?> get props => [
    name, subtitle, costPrice, salePrice, volume, category,
    stock, description, isNewArrival, isFeatured, imagePath,
  ];
}

class FetchProductsRequested extends ProductEvent {
  const FetchProductsRequested();
}

class DeleteProductRequested extends ProductEvent {
  final String productId;
  const DeleteProductRequested(this.productId);

  @override
  List<Object?> get props => [productId];
}

class UpdateProductRequested extends ProductEvent {
  final String  productId;
  final String  name;
  final String  subtitle;
  final double  costPrice;
  final double  salePrice;
  final int     volume;
  final String  category;
  final int     stock;
  final String  description;
  final bool    isNewArrival;
  final bool    isFeatured;
  final String  existingImageUrl;
  final String? imagePath;

  const UpdateProductRequested({
    required this.productId,
    required this.name,
    required this.subtitle,
    required this.costPrice,
    required this.salePrice,
    required this.volume,
    required this.category,
    required this.stock,
    required this.description,
    required this.isNewArrival,
    required this.isFeatured,
    required this.existingImageUrl,
    this.imagePath,
  });

  @override
  List<Object?> get props => [
    productId, name, subtitle, costPrice, salePrice, volume, category,
    stock, description, isNewArrival, isFeatured, imagePath, existingImageUrl,
  ];
}