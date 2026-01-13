import 'package:equatable/equatable.dart';
import 'package:presupresto/models/History.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final History history;

  const HistoryLoaded({required this.history});

  @override
  List<Object?> get props => [history];
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
