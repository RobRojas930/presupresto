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
    return User.fromJson(data['data'] ?? data);
  }
}
