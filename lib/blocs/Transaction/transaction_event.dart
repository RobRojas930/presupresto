import 'package:equatable/equatable.dart';
import 'package:presupresto/models/transaction.dart';

abstract class TransactionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTransactions extends TransactionEvent {
  final String userId;
  final DateTime startDate;
  final DateTime endDate;

  LoadTransactions({
    required this.userId,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [userId, startDate, endDate];
}

class AddTransaction extends TransactionEvent {
  final Transaction transaction;
  final DateTime startDate;
  final DateTime endDate;
  AddTransaction(this.transaction, this.startDate, this.endDate);
  @override
  List<Object?> get props => [transaction, startDate, endDate];
}

class UpdateTransaction extends TransactionEvent {
  final Transaction transaction;
  UpdateTransaction(this.transaction);
  @override
  List<Object?> get props => [transaction];
}

class DeleteTransaction extends TransactionEvent {
  final String id;
  DeleteTransaction(this.id);
  @override
  List<Object?> get props => [id];
}
