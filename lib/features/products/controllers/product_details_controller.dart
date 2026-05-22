import 'package:flutter/material.dart';
import '../repositories/product_repository.dart';
import 'product_details_state.dart';

class ProductDetailsController {
  final ProductRepository repository;
  final ValueNotifier<ProductDetailsState> state = ValueNotifier(ProductDetailsInitial());

  ProductDetailsController(this.repository);

  Future<void> loadProductDetails(int id) async {
    state.value = ProductDetailsLoading();
    try {
      final product = await repository.getProductDetails(id);
      state.value = ProductDetailsSuccess(product);
    } catch (e) {
      state.value = ProductDetailsError(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
