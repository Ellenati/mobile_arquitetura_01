import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../controllers/product_controller.dart';
import 'product_details_screen.dart';
import 'login_screen.dart';

class ProductsScreen extends StatefulWidget {
  final AuthController authController;
  final ProductController productController;
  const ProductsScreen({super.key, required this.authController, required this.productController});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.authController.isAuthenticated) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(authController: widget.authController, productController: widget.productController)));
      } else {
        widget.productController.fetchProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.authController.state.value.currentUser;
    final name = user != null ? '${user.firstName} ${user.lastName}' : 'Usuário';

    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, $name'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              widget.productController.clearFavorites();
              widget.authController.logout();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(authController: widget.authController, productController: widget.productController)));
            },
          )
        ],
      ),
      body: ValueListenableBuilder<ProductState>(
        valueListenable: widget.productController.state,
        builder: (context, state, _) {
          if (state.isLoading) return const Center(child: CircularProgressIndicator());
          if (state.errorMessage != null) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(state.errorMessage!, style: const TextStyle(color: Colors.red)), ElevatedButton(onPressed: () => widget.productController.fetchProducts(), child: const Text('Tentar Novamente'))]));
          }
          return ListView.builder(
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              final isFav = state.favoriteIds.contains(product.id);
              return ListTile(
                leading: Image.network(product.thumbnail, width: 50, height: 50, fit: BoxFit.cover),
                title: Text(product.title),
                subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : null),
                  onPressed: () => widget.productController.toggleFavorite(product.id),
                ),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: product, productController: widget.productController))),
              );
            },
          );
        },
      ),
    );
  }
}
