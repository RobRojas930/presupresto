import '../services/auth_service.dart';
import '../models/user.dart';

class AuthRepository {
  final AuthService service;
  AuthRepository(this.service);

  Future<Map<String, dynamic>> login(String email, String password) =>
      service.login(email, password);

  Future<Map<String, dynamic>> signup(
          String name, String email, String password) =>
      service.signup(name, email, password);

  User? parseUser(Map<String, dynamic> data) {
    if (data['user'] != null)
      return User.fromJson(data['user'] as Map<String, dynamic>);
    return null;
  }
}
