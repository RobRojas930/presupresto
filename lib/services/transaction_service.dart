import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:presupresto/models/transaction.dart';

class TransactionService {
  final String baseUrl;
  TransactionService({required this.baseUrl});
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<List<Transaction>> getTransactions(String token) async {
    try {
      SecurityContext.defaultContext.allowLegacyUnsafeRenegotiation = true;
      final response = await http.get(
        Uri.parse('$baseUrl/transaction'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ' + token,
          'Accept': 'application/json'
        },
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final List<dynamic> jsonDataList = jsonData['data'];
        List<Transaction> transactions = [];
        jsonDataList.forEach(
          (item) {
            transactions.add(Transaction.fromJson(item));
          },
        );
        return transactions;
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Transaction> createTransaction(Map<String, Transaction> data) async {
    try {
      final token = await _storage.read(key: 'token');

      final response = await http.post(
        Uri.parse('$baseUrl/transaction'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': '$token'
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create transaction');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/transaction/$id'),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete transaction');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
