import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final User? currentUser;
  AuthState({this.isLoading = false, this.errorMessage, this.currentUser});

  AuthState copyWith({bool? isLoading, String? errorMessage, User? currentUser}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}

class AuthController {
  final ApiService _apiService = ApiService();
  final ValueNotifier<AuthState> state = ValueNotifier(AuthState());
  bool get isAuthenticated => state.value.currentUser != null;

  Future<void> login(String username, String password) async {
    state.value = state.value.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _apiService.login(username, password);
      state.value = state.value.copyWith(isLoading: false, currentUser: user);
    } catch (e) {
      state.value = state.value.copyWith(isLoading: false, errorMessage: e.toString().replaceAll('Exception: ', ''));
    }
  }
  void logout() { state.value = AuthState(); }
}
