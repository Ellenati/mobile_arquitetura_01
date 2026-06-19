import 'package:flutter/material.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/views/login_page.dart';
import 'features/products/controllers/product_controller.dart';
import 'features/products/controllers/product_details_controller.dart';

class MainApp extends StatelessWidget {
  final AuthController authController;
  final ProductController productController;
  final ProductDetailsController detailsController;

  const MainApp({
    super.key,
    required this.authController,
    required this.productController,
    required this.detailsController,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lojinha Virtual',
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
