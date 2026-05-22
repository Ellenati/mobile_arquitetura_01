import '../models/user_model.dart';

class SessionService {
  UserModel? _currentUser;

  void saveUser(UserModel user) {
    _currentUser = user;
  }

  UserModel? getUser() {
    return _currentUser;
  }

  void clearSession() {
    _currentUser = null;
  }
}
