import 'package:flutter/material.dart';
import '../repositories/product_repository.dart';
import 'product_controller.dart';
import 'product_details_state.dart';
import 'product_state.dart';

class ProductDetailsController {
  final ProductRepository repository;
  final ProductController productController;
  final ValueNotifier<ProductDetailsState> state = ValueNotifier(
    ProductDetailsInitial(),
  );

  ProductDetailsController(this.repository, this.productController);

  Future<void> loadProductDetails(int id) async {
    final productState = productController.state.value;
    if (productState is ProductSuccess) {
      try {
        final cachedProduct = productState.products.firstWhere(
          (product) => product.id == id,
        );
        state.value = ProductDetailsSuccess(cachedProduct);
        return;
      } catch (e) {
        // Product not found in cache, will fetch from API below
      }
    }

    state.value = ProductDetailsLoading();
    try {
      final product = await repository.getProductDetails(id);
      state.value = ProductDetailsSuccess(product);
    } catch (e) {
      state.value = ProductDetailsError(
        e.toString().replaceAll("Exception: ", ""),
      );
    }
  }
}
