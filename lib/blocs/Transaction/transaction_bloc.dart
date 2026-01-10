import 'dart:async';
import 'package:bloc/bloc.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';
import 'package:presupresto/repositories/transaction_repository.dart';
import 'package:presupresto/models/transaction.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository repository;

  TransactionBloc(this.repository) : super(TransactionInitial()) {
    on<LoadTransactions>(_onLoad);
    on<AddTransaction>(_onAdd);
    on<UpdateTransaction>(_onUpdate);
    on<DeleteTransaction>(_onDelete);
  }

  Future<void> _onLoad(
      LoadTransactions event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    try {
      final items = await repository.fetchAllByFilter(
        filter: {
          'userId': event.userId,
          'startDate': event.startDate.toIso8601String(),
          'endDate': event.endDate.toIso8601String(),
        },
      );
      emit(TransactionLoaded(items));
    } catch (e) {
      emit(TransactionFailure(e.toString()));
    }
  }

  Future<void> _onAdd(
      AddTransaction event, Emitter<TransactionState> emit) async {
    final current = state is TransactionLoaded
        ? (state as TransactionLoaded).items
        : <Transaction>[];
    emit(TransactionLoading());
    try {
      final created = await repository.create(event.transaction);
      if (created.date.isBefore(event.endDate) &&
          created.date.isAfter(event.startDate)) {
        emit(TransactionLoaded([created, ...current]));
        return;
      } else {
        emit(TransactionLoaded([...current]));
        return;
      }
    } catch (e) {
      emit(TransactionFailure(e.toString()));
    }
  }

  Future<void> _onUpdate(
      UpdateTransaction event, Emitter<TransactionState> emit) async {
    final current = state is TransactionLoaded
        ? (state as TransactionLoaded).items
        : <Transaction>[];
    emit(TransactionLoading());
    try {
      final updated = await repository.update(event.transaction);
      final list =
          current.map((t) => t.id == updated.id ? updated : t).toList();
      emit(TransactionLoaded(list));
    } catch (e) {
      emit(TransactionFailure(e.toString()));
    }
  }

  Future<void> _onDelete(
      DeleteTransaction event, Emitter<TransactionState> emit) async {
    final current = state is TransactionLoaded
        ? (state as TransactionLoaded).items
        : <Transaction>[];
    emit(TransactionLoading());
    try {
      await repository.delete(event.id);
      final list = current.where((t) => t.id != event.id).toList();
      emit(TransactionLoaded(list));
    } catch (e) {
      emit(TransactionFailure(e.toString()));
    }
  }
}
