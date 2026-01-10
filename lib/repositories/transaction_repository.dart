import 'package:presupresto/models/transaction.dart';
import 'package:presupresto/services/transaction_service.dart';

class TransactionRepository {
  final TransactionService _service;

  TransactionRepository({required TransactionService service})
      : _service = service;

  Future<List<Transaction>> fetchAll({String? tokenOverride}) async {
    return _service.getTransactions(tokenOverride ?? '');
  }

  Future<List<Transaction>> fetchAllByFilter(
      {String? tokenOverride, Map<String, dynamic>? filter}) async {
    return _service.getTransactionsByFilter(tokenOverride ?? '', filter ?? {});
  }

  Future<Transaction> create(Transaction tx, {String? tokenOverride}) async {
    return _service.createTransaction({'transaction': tx});
  }

  Future<Transaction> update(Transaction tx, {String? tokenOverride}) async {
    return _service.updateTransaction({'transaction': tx});
  }

  Future<void> delete(String id, {String? tokenOverride}) async {
    return _service.deleteTransaction(id);
  }
}
