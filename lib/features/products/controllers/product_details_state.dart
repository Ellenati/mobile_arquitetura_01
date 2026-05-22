import '../models/product_model.dart';

sealed class ProductDetailsState {}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsSuccess extends ProductDetailsState {
  final ProductModel product;
  ProductDetailsSuccess(this.product);
}

class ProductDetailsError extends ProductDetailsState {
  final String message;
  ProductDetailsError(this.message);
}
