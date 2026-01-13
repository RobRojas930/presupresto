import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:presupresto/models/dashboard.dart';

class DashBoardService {
  final String baseUrl;
  DashBoardService({required this.baseUrl});

  Future<Dashboard> getDashboardData(
      String token, Map<String, dynamic> filter) async {
    SecurityContext.defaultContext.allowLegacyUnsafeRenegotiation = true;

    // Convertir el map de filtros a query parameters
    final queryParameters =
        filter.map((key, value) => MapEntry(key, value.toString()));
    final userId = filter['userId'] ?? '';
    final uri = Uri.parse('$baseUrl/user/dashboard/$userId')
        .replace(queryParameters: queryParameters);

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'authorization': token,
        'Accept': 'application/json'
      },
    ).timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Dashboard.fromJson(jsonData['data']);
    } else {
      throw Exception('No se encontró información del dashboard');
    }
  }
}
