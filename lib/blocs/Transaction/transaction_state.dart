import 'package:equatable/equatable.dart';
import 'package:presupresto/models/transaction.dart';

abstract class TransactionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<Transaction> items;
  TransactionLoaded(this.items);
  @override
  List<Object?> get props => [items];
}

class TransactionFailure extends TransactionState {
  final String message;
  TransactionFailure(this.message);
  @override
  List<Object?> get props => [message];
}