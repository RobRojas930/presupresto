import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:presupresto/models/budget.dart';

class BudgetService {
  String baseUrl;

  BudgetService({required this.baseUrl});
  Future<List<Budget>> getBudgets() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/budget'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al cargar presupuestos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<List<Budget>> getBudgetData(
      String token, Map<String, dynamic> filter) async {
    try {
      SecurityContext.defaultContext.allowLegacyUnsafeRenegotiation = true;
// Convertir el map de filtros a query parameters
      final queryParameters =
          filter.map((key, value) => MapEntry(key, value.toString()));

      final uri = Uri.parse('$baseUrl/budget/data')
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
        final jsonData = jsonDecode(response.body);
        final List<dynamic> jsonDataList = jsonData['data'];
        return jsonDataList.map((json) => Budget.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar presupuestos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Budget?> getBudgetById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/budget/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al cargar presupuesto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Budget?> createBudget(Budget budgetData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/budget'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(budgetData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Budget.fromJson(jsonDecode(response.body)['data']);
      } else {
        throw Exception('Error al crear presupuesto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Budget?> updateBudget(String id, Budget budgetData) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/budget/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(budgetData),
      );

      if (response.statusCode == 200) {
        return Budget.fromJson(jsonDecode(response.body)['actualizado']);
      } else {
        throw Exception(
            'Error al actualizar presupuesto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<void> deleteBudget(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/budget/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
            'Error al eliminar presupuesto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
