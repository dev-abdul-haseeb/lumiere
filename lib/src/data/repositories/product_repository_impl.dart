import 'package:lumiere/src/data/datasources/product_remote_datasource.dart';
import 'package:lumiere/src/data/models/products_model.dart';
import 'package:lumiere/src/domain/entities/products.dart';
import 'package:lumiere/src/domain/repositories/product_repository.dart';

class ProductRepositoryImpl extends ProductRepository {
  final ProductRemoteDatasource _productRemoteDatasource;

  ProductRepositoryImpl({required ProductRemoteDatasource productRemoteDatasource})
      : _productRemoteDatasource = productRemoteDatasource;

  @override
  Future<void> addProduct(Products product, {String? imageLocalPath}) async {
    await _productRemoteDatasource.addProduct(
      _toModel(product),
      imageLocalPath: imageLocalPath,
    );
  }

  @override
  Future<List<Products>> fetchProducts() async {
    return await _productRemoteDatasource.fetchProducts();
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await _productRemoteDatasource.deleteProduct(productId);
  }

  @override
  Future<void> updateProduct(Products product, {String? imageLocalPath}) async {
    await _productRemoteDatasource.updateProduct(
      _toModel(product),
      imageLocalPath: imageLocalPath,
    );
  }

  ProductsModel _toModel(Products p) => ProductsModel(
    productId:      p.productId,
    productName:    p.productName,
    subtitle:       p.subtitle,
    description:    p.description,
    category:       p.category,
    volume:         p.volume,
    stock_quantity: p.stock_quantity,
    cost_price:     p.cost_price,
    sale_price:     p.sale_price,
    image_link:     p.image_link,
    isNewArrival:   p.isNewArrival,
    isFeatured:     p.isFeatured,
  );
}