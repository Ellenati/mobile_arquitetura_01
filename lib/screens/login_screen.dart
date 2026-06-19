import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../controllers/product_controller.dart';
import 'products_screen.dart';

class LoginScreen extends StatefulWidget {
  final AuthController authController;
  final ProductController productController;
  const LoginScreen({super.key, required this.authController, required this.productController});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.authController.state.addListener(_onAuthStateChanged);
  }

  @override
  void dispose() {
    widget.authController.state.removeListener(_onAuthStateChanged);
    _usernameController.dispose(); _passwordController.dispose();
    super.dispose();
  }

  void _onAuthStateChanged() {
    final state = widget.authController.state.value;
    if (state.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red));
    }
    if (widget.authController.isAuthenticated) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductsScreen(authController: widget.authController, productController: widget.productController)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acesso à Loja')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Usuário', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Insira o usuário' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Senha', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Insira a senha' : null),
              const SizedBox(height: 24),
              ValueListenableBuilder<AuthState>(
                valueListenable: widget.authController.state,
                builder: (context, state, _) {
                  return SizedBox(
                    width: double.infinity, height: 50,
                    child: ElevatedButton(
                      onPressed: state.isLoading ? null : () { if (_formKey.currentState!.validate()) widget.authController.login(_usernameController.text.trim(), _passwordController.text.trim()); },
                      child: state.isLoading ? const CircularProgressIndicator() : const Text('ENTRAR'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
