import 'package:flutter/material.dart';
import '../repositories/product_repository.dart';
import 'product_state.dart';

class ProductController {
  final ProductRepository repository;
  final ValueNotifier<ProductState> state = ValueNotifier(ProductInitial());

  ProductController(this.repository);

  Future<void> loadProducts() async {
    state.value = ProductLoading();
    try {
      final products = await repository.getProducts();
      state.value = ProductSuccess(products);
    } catch (e) {
      state.value = ProductError(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
