import 'package:flutter/material.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/views/login_page.dart';
import '../controllers/product_controller.dart';
import '../controllers/product_details_controller.dart';
import '../controllers/product_state.dart';
import 'product_details_page.dart';

class ProductPage extends StatefulWidget {
  final ProductController controller;
  final AuthController authController;
  final ProductDetailsController detailsController;

  const ProductPage({
    super.key,
    required this.controller,
    required this.authController,
    required this.detailsController,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.state.addListener(_onStateChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.loadProducts();
    });
  }

  @override
  void dispose() {
    widget.controller.state.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    final state = widget.controller.state.value;
    if (state is ProductError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _logout() {
    widget.authController.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LoginPage(
          authController: widget.authController,
          productController: widget.controller,
          detailsController: widget.detailsController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Produtos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: ValueListenableBuilder<ProductState>(
        valueListenable: widget.controller.state,
        builder: (context, state, _) {
          return switch (state) {
            ProductInitial() || ProductLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            ProductSuccess(products: final products) => ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    leading: Image.network(
                      product.thumbnail,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                    ),
                    title: Text(product.title),
                    subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailsPage(
                            productId: product.id,
                            controller: widget.detailsController,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ProductError(message: final message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(message, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: widget.controller.loadProducts,
                        icon: const Icon(Icons.refresh),
                        label: const Text("Tentar Novamente"),
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
