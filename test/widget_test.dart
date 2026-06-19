import 'package:flutter_test/flutter_test.dart';
import 'package:product_app/main_app.dart';
import 'package:product_app/features/auth/controllers/auth_controller.dart';
import 'package:product_app/features/auth/repositories/auth_repository.dart';
import 'package:product_app/features/auth/services/auth_service.dart';
import 'package:product_app/features/auth/services/session_service.dart';
import 'package:product_app/features/products/controllers/product_controller.dart';
import 'package:product_app/features/products/controllers/product_details_controller.dart';
import 'package:product_app/features/products/repositories/product_repository.dart';
import 'package:product_app/features/products/services/product_cache_service.dart';
import 'package:product_app/features/products/services/product_service.dart';

void main() {
  testWidgets('App renders login page test', (WidgetTester tester) async {
    final sessionService = SessionService();
    final authService = AuthService();
    final authRepository = AuthRepository(authService, sessionService);
    final authController = AuthController(authRepository);

    final productService = ProductService();
    final productCacheService = ProductCacheService();
    final productRepository = ProductRepository(
      productService,
      productCacheService,
    );
    final productController = ProductController(productRepository);
    final productDetailsController = ProductDetailsController(
      productRepository,
      productController,
    );

    await tester.pumpWidget(
      MainApp(
        authController: authController,
        productController: productController,
        detailsController: productDetailsController,
      ),
    );

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('ENTRAR'), findsOneWidget);
  });
}
