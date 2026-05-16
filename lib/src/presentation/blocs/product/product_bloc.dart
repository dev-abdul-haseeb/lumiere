import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:lumiere/src/domain/entities/products.dart';
import 'package:lumiere/src/domain/repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _repository;
  final _uuid = const Uuid();

  ProductBloc({required ProductRepository repository})
      : _repository = repository,
        super(const ProductInitial()) {
    on<FetchProductsRequested>(_onFetch);
    on<AddProductRequested>(_onAdd);
    on<DeleteProductRequested>(_onDelete);
    on<UpdateProductRequested>(_onUpdate);
  }

  Future<void> _onFetch(FetchProductsRequested event, Emitter<ProductState> emit,) async {
    emit(const ProductLoading());
    try {
      final products = await _repository.fetchProducts();
      emit(ProductsFetched(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onAdd(
      AddProductRequested event,
      Emitter<ProductState> emit,
      ) async {
    emit(const ProductLoading());
    try {
      final product = Products(
        productId:      _uuid.v4(),
        productName:    event.name,
        subtitle:       event.subtitle,
        description:    event.description,
        category:       event.category,
        volume:         event.volume,
        stock_quantity: event.stock,
        cost_price:     event.costPrice,   // ← separate
        sale_price:     event.salePrice,   // ← separate
        image_link:     '',
        isNewArrival:   event.isNewArrival,
        isFeatured:     event.isFeatured,
      );

      await _repository.addProduct(product, imageLocalPath: event.imagePath);
      emit(const ProductAdded());

      final products = await _repository.fetchProducts();
      emit(ProductsFetched(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onUpdate(
      UpdateProductRequested event,
      Emitter<ProductState> emit,
      ) async {
    emit(const ProductLoading());
    try {
      final product = Products(
        productId:      event.productId,
        productName:    event.name,
        subtitle:       event.subtitle,
        description:    event.description,
        category:       event.category,
        volume:         event.volume,
        stock_quantity: event.stock,
        cost_price:     event.costPrice,   // ← separate
        sale_price:     event.salePrice,   // ← separate
        image_link:     event.existingImageUrl,
        isNewArrival:   event.isNewArrival,
        isFeatured:     event.isFeatured,
      );

      await _repository.updateProduct(product, imageLocalPath: event.imagePath);
      emit(const ProductUpdated());

      final products = await _repository.fetchProducts();
      emit(ProductsFetched(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
  Future<void> _onDelete(
      DeleteProductRequested event,
      Emitter<ProductState> emit,
      ) async {
    emit(const ProductLoading());
    try {
      await _repository.deleteProduct(event.productId);
      emit(const ProductDeleted());

      final products = await _repository.fetchProducts();
      emit(ProductsFetched(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}