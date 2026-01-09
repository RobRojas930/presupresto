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
            final Map<String, dynamic> itemJsonData = item;
            itemJsonData['category'] = itemJsonData['category'][0];
            transactions.add(Transaction.fromJson(itemJsonData));
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
        body: jsonEncode(data['transaction']),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final Map<String, dynamic> data = jsonData['data'];
        data['category'] = data['category'][0];
        return Transaction.fromJson(data);
      } else {
        throw Exception('Failed to create transaction');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Transaction> updateTransaction(Map<String, Transaction> data) async {
    try {
      final token = await _storage.read(key: 'token');
      final response = await http.put(
        Uri.parse('$baseUrl/transaction/${data['transaction']!.id}'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': '$token'
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        return Transaction.fromJson(jsonDecode(response.body)['data']);
      } else {
        throw Exception('Failed to update transaction');
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
