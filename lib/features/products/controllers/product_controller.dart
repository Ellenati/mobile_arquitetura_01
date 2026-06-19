import 'package:flutter/material.dart';
import '../repositories/product_repository.dart';
import 'product_state.dart';

class ProductController {
  final ProductRepository repository;
  final ValueNotifier<ProductState> state = ValueNotifier(ProductInitial());

  final Map<int, Set<int>> _usersFavoritesCache = {};

  int? _activeUserId;

  ProductController(this.repository);

  void setActiveUser(int userId) {
    _activeUserId = userId;
    final currentState = state.value;
    if (currentState is ProductSuccess) {
      final userFavorites = _usersFavoritesCache[userId] ?? <int>{};
      state.value = ProductSuccess(
        currentState.products,
        favoriteIds: userFavorites,
      );
    }
  }

  Future<void> loadProducts({bool forceRefresh = false}) async {
    final shouldShowLoading = forceRefresh || state.value is! ProductSuccess;

    if (shouldShowLoading) {
      state.value = ProductLoading();
    }

    try {
      final products = await repository.getProducts();
      final existingState = state.value;
      final favorites = existingState is ProductSuccess
          ? existingState.favoriteIds
          : <int>{};
      state.value = ProductSuccess(products, favoriteIds: favorites);
    } catch (e) {
      state.value = ProductError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  void toggleFavorite(int productId) {
    if (_activeUserId == null) return;

    final currentState = state.value;
    if (currentState is ProductSuccess) {
      final updatedFavorites = Set<int>.from(currentState.favoriteIds);
      if (updatedFavorites.contains(productId)) {
        updatedFavorites.remove(productId);
      } else {
        updatedFavorites.add(productId);
      }

      // Update state
      state.value = ProductSuccess(
        currentState.products,
        favoriteIds: updatedFavorites,
      );

      // Persist to multi-tenant cache
      _usersFavoritesCache[_activeUserId!] = updatedFavorites;
    }
  }

  void clearActiveSession() {
    _activeUserId = null;
    final currentState = state.value;
    if (currentState is ProductSuccess) {
      state.value = ProductSuccess(currentState.products, favoriteIds: <int>{});
    }
  }

  void clearFavorites() {
    clearActiveSession();
  }
}
