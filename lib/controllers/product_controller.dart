import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductState {
  final bool isLoading;
  final String? errorMessage;
  final List<Product> products;
  final Set<int> favoriteIds;
  ProductState({this.isLoading = false, this.errorMessage, this.products = const [], this.favoriteIds = const {}});

  ProductState copyWith({bool? isLoading, String? errorMessage, List<Product>? products, Set<int>? favoriteIds}) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      products: products ?? this.products,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }
}

class ProductController {
  final ApiService _apiService = ApiService();
  final ValueNotifier<ProductState> state = ValueNotifier(ProductState());

  Future<void> fetchProducts() async {
    state.value = state.value.copyWith(isLoading: true, errorMessage: null);
    try {
      final list = await _apiService.getProducts();
      state.value = state.value.copyWith(isLoading: false, products: list);
    } catch (e) {
      state.value = state.value.copyWith(isLoading: false, errorMessage: e.toString().replaceAll('Exception: ', ''));
    }
  }

  void toggleFavorite(int productId) {
    final currentFavs = Set<int>.from(state.value.favoriteIds);
    if (currentFavs.contains(productId)) { currentFavs.remove(productId); } else { currentFavs.add(productId); }
    state.value = state.value.copyWith(favoriteIds: currentFavs);
  }

  void clearFavorites() { state.value = state.value.copyWith(favoriteIds: const {}); }
}
