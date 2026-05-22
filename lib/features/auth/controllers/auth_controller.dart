import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthController {
  final AuthRepository repository;
  final ValueNotifier<AuthState> state = ValueNotifier(AuthInitial());

  AuthController(this.repository);

  Future<void> login(String username, String password) async {
    state.value = AuthLoading();
    try {
      await repository.login(username, password);
      state.value = AuthSuccess();
    } catch (e) {
      state.value = AuthError(e.toString().replaceAll("Exception: ", ""));
    }
  }

  void logout() {
    repository.logout();
    state.value = AuthInitial();
  }
}
