import '../models/product_model.dart';

sealed class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductSuccess extends ProductState {
  final List<ProductModel> products;
  final Set<int> favoriteIds;
  ProductSuccess(this.products, {this.favoriteIds = const {}});
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}
