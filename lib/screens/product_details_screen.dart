import 'package:flutter/material.dart';
import '../models/product.dart';
import '../controllers/product_controller.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  final ProductController productController;
  const ProductDetailsScreen({super.key, required this.product, required this.productController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes'), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.thumbnail, width: double.infinity, height: 250, fit: BoxFit.contain),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(product.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                      ValueListenableBuilder<ProductState>(
                        valueListenable: productController.state,
                        builder: (context, state, _) {
                          final isFav = state.favoriteIds.contains(product.id);
                          return IconButton(icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : null, size: 28), onPressed: () => productController.toggleFavorite(product.id));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text(product.description, style: const TextStyle(fontSize: 16, height: 1.4)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
