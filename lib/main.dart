import 'package:flutter/material.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/repositories/auth_repository.dart';
import 'features/auth/services/auth_service.dart';
import 'features/auth/services/session_service.dart';
import 'features/products/controllers/product_controller.dart';
import 'features/products/controllers/product_details_controller.dart';
import 'features/products/repositories/product_repository.dart';
import 'features/products/services/product_cache_service.dart';
import 'features/products/services/product_service.dart';
import 'main_app.dart';

void main() {
  // Initialize services
  final authService = AuthService();
  final sessionService = SessionService();
  final authRepository = AuthRepository(authService, sessionService);
  final authController = AuthController(authRepository);

  final productService = ProductService();
  final productCacheService = ProductCacheService();
  final productRepository = ProductRepository(
    productService,
    productCacheService,
  );
  final productController = ProductController(productRepository);
  final detailsController = ProductDetailsController(
    productRepository,
    productController,
  );

  runApp(
    MainApp(
      authController: authController,
      productController: productController,
      detailsController: detailsController,
    ),
  );
}
