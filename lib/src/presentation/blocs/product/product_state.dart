part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductAdded extends ProductState {
  const ProductAdded();
}

class ProductUpdated extends ProductState {
  const ProductUpdated();
}

class ProductDeleted extends ProductState {
  const ProductDeleted();
}

class ProductsFetched extends ProductState {
  final List<Products> products;
  const ProductsFetched(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}