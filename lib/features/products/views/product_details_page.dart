import 'package:flutter/material.dart';
import '../controllers/product_controller.dart';
import '../controllers/product_details_controller.dart';
import '../controllers/product_details_state.dart';
import '../controllers/product_state.dart';

class ProductDetailsPage extends StatefulWidget {
  final int productId;
  final ProductDetailsController controller;
  final ProductController productController;

  const ProductDetailsPage({
    super.key,
    required this.productId,
    required this.controller,
    required this.productController,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.loadProductDetails(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalhes do Produto")),
      body: ValueListenableBuilder<ProductDetailsState>(
        valueListenable: widget.controller.state,
        builder: (context, state, _) {
          return switch (state) {
            ProductDetailsInitial() || ProductDetailsLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            ProductDetailsSuccess(product: final product) =>
              ValueListenableBuilder<ProductState>(
                valueListenable: widget.productController.state,
                builder: (context, productState, _) {
                  final isFav = switch (productState) {
                    ProductSuccess(favoriteIds: final favs) => favs.contains(
                      product.id,
                    ),
                    _ => false,
                  };
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.network(
                            product.thumbnail,
                            height: 250,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image, size: 200),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                product.title,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? Colors.red : null,
                                size: 28,
                              ),
                              onPressed: () => widget.productController
                                  .toggleFavorite(product.id),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "\$${product.price.toStringAsFixed(2)}",
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Descrição",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(product.description),
                      ],
                    ),
                  );
                },
              ),
            ProductDetailsError(message: final message) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => widget.controller.loadProductDetails(
                        widget.productId,
                      ),
                      child: const Text("Tentar Novamente"),
                    ),
                  ],
                ),
              ),
            ),
          };
        },
      ),
    );
  }
}
