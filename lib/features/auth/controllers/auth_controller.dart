import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthController {
  final AuthRepository repository;
  final ValueNotifier<AuthState> state = ValueNotifier(AuthInitial());
  UserModel? _currentUser;

  AuthController(this.repository);

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  Future<void> login(String username, String password) async {
    state.value = AuthLoading();
    try {
      final user = await repository.login(username, password);
      _currentUser = user;
      state.value = AuthSuccess();
    } catch (e) {
      state.value = AuthError(e.toString().replaceAll("Exception: ", ""));
    }
  }

  void logout() {
    repository.logout();
    _currentUser = null;
    state.value = AuthInitial();
  }
}
