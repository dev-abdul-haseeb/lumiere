import 'package:lumiere/src/domain/entities/products.dart';

abstract class ProductRepository {
  Future<void> addProduct(Products product, {String? imageLocalPath});
  Future<List<Products>> fetchProducts();
  Future<void> deleteProduct(String productId);
  Future<void> updateProduct(Products product, {String? imageLocalPath});
}