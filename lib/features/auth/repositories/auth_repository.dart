import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/session_service.dart';

class AuthRepository {
  final AuthService authService;
  final SessionService sessionService;

  AuthRepository(this.authService, this.sessionService);

  Future<UserModel> login(String username, String password) async {
    final user = await authService.login(username, password);
    sessionService.saveUser(user);
    return user;
  }

  void logout() {
    sessionService.clearSession();
  }
}
