import 'package:flutter/material.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/repositories/auth_repository.dart';
import 'features/auth/services/auth_service.dart';
import 'features/auth/services/session_service.dart';
import 'features/auth/views/login_page.dart';
import 'features/products/controllers/product_controller.dart';
import 'features/products/controllers/product_details_controller.dart';
import 'features/products/repositories/product_repository.dart';
import 'features/products/services/product_cache_service.dart';
import 'features/products/services/product_service.dart';

void main() {
  // Injeção de dependências - Auth
  final sessionService = SessionService();
  final authService = AuthService();
  final authRepository = AuthRepository(authService, sessionService);
  final authController = AuthController(authRepository);

  // Injeção de dependências - Products
  final productService = ProductService();
  final productCacheService = ProductCacheService();
  final productRepository = ProductRepository(productService, productCacheService);
  final productController = ProductController(productRepository);
  final productDetailsController = ProductDetailsController(productRepository);

  runApp(MyApp(
    authController: authController,
    productController: productController,
    detailsController: productDetailsController,
  ));
}

class MyApp extends StatelessWidget {
  final AuthController authController;
  final ProductController productController;
  final ProductDetailsController detailsController;

  const MyApp({
    super.key,
    required this.authController,
    required this.productController,
    required this.detailsController,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: LoginPage(
        authController: authController,
        productController: productController,
        detailsController: detailsController,
      ),
    );
  }
}
