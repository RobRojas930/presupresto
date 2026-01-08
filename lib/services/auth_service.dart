import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl;
  AuthService({required this.baseUrl});

  Future<Map<String, dynamic>> login(String email, String password) async {
    final resp = await http.post(
      Uri.parse('$baseUrl/user/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (resp.statusCode == 200)
      return jsonDecode(resp.body) as Map<String, dynamic>;
    throw Exception('Login failed: ${resp.statusCode} ${resp.body}');
  }

  Future<Map<String, dynamic>> signup(
      String name, String email, String password) async {
    final resp = await http.post(
      Uri.parse('$baseUrl/user/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    if (resp.statusCode == 200 || resp.statusCode == 201)
      return jsonDecode(resp.body) as Map<String, dynamic>;
    throw Exception('Signup failed: ${resp.statusCode} ${resp.body}');
  }
}
