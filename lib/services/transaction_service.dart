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

  Future<List<Transaction>> getTransactionsByFilter(
      String token, Map<String, dynamic> filter) async {
    try {
      SecurityContext.defaultContext.allowLegacyUnsafeRenegotiation = true;

      // Convertir el map de filtros a query parameters
      final queryParameters =
          filter.map((key, value) => MapEntry(key, value.toString()));

      final uri = Uri.parse('$baseUrl/transaction')
          .replace(queryParameters: queryParameters);

      final response = await http.get(
        uri,
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
            item['category'] = item['category'][0];
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
        body: jsonEncode(data['transaction']),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final Map<String, dynamic> newdata = jsonData['data'];
        newdata['category'] = newdata['category'][0];
        return Transaction.fromJson(newdata);
      } else {
        throw Exception('Failed to create transaction');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Transaction> updateTransaction(Map<String, Transaction> data) async {
    try {
      final id = data['transaction']!.id;
      final dataTransaction = data['transaction']!.toJson();
      dataTransaction.remove('id');
      final token = await _storage.read(key: 'token');
      final response = await http.patch(
        Uri.parse('$baseUrl/transaction/$id}'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': '$token'
        },
        body: jsonEncode(dataTransaction),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final Map<String, dynamic> newData = jsonData['actualizado'];
        newData['category'] = newData['category'][0];
        return Transaction.fromJson(newData);
      } else {
        throw Exception('Failed to update transaction');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      final token = await _storage.read(key: 'token');
      final response = await http.delete(
        Uri.parse('$baseUrl/transaction/$id'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': '$token'
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete transaction');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
