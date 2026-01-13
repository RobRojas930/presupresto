import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:presupresto/models/History.dart';

class HistoryService {
  final String baseUrl;

  HistoryService({required this.baseUrl});

  /// Obtiene el historial del usuario
  Future<History> getHistory(String userId, Map<String, dynamic> filter) async {
    try {
      final queryParameters =
          filter.map((key, value) => MapEntry(key, value.toString()));

      final uri = Uri.parse('$baseUrl/user/history/$userId')
          .replace(queryParameters: queryParameters);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body)['data'];
        return History.fromJson(data);
      } else {
        throw Exception(
            'Error al obtener el historial: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
