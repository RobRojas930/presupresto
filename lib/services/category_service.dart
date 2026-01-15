import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:presupresto/models/category.dart';
import 'package:presupresto/utils/constants.dart';

class CategoryService {
  final String baseUrl;

  CategoryService({required this.baseUrl});

  Future<List<Category>> getCategories(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      print(data);
      final List<Category> categories =
          data.map((json) => Category.fromJson(json)).toList();
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<Category> getCategoryById(String token, String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body)['data'];
      return Category.fromJson(data);
    } else {
      throw Exception('Failed to load category');
    }
  }

  Future<List<Category>> getCategoriesByFilter(
      String token, Map<String, dynamic> filter) async {
    try {
      SecurityContext.defaultContext.allowLegacyUnsafeRenegotiation = true;

      // Convertir el map de filtros a query parameters
      final queryParameters =
          filter.map((key, value) => MapEntry(key, value.toString()));

      final uri = Uri.parse('$baseUrl/categories')
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
        final List<dynamic> jsonDataList = jsonData['data'];
        List<Category> categories = [];
        jsonDataList.forEach(
          (item) {
            categories.add(Category.fromJson(item));
          },
        );
        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<Category> createCategory(String token, Category category) async {
    final response = await http.post(
      Uri.parse('$baseUrl/categories'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(category.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body)['data'];
      return Category.fromJson(data);
    } else {
      throw Exception('Failed to create category');
    }
  }

  Future<Category> updateCategory(String token, Category category) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/categories/${category.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(category.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data =
          json.decode(response.body)['actualizado'];
      return Category.fromJson(data);
    } else {
      throw Exception('Failed to update category');
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/categories/$id'),
        headers: {'Content-Type': 'application/json', 'authorization': ''},
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('${jsonDecode(response.body)['message']}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}
