import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:presupresto/blocs/History/history_event.dart';
import 'package:presupresto/blocs/History/history_state.dart';
import '../../repositories/history_repository.dart';


class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository historyRepository;

  HistoryBloc({required this.historyRepository}) : super(HistoryInitial()) {
    on<LoadHistoryData>(_onLoadHistory);
  }

  Future<void> _onLoadHistory(
    LoadHistoryData event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    try {
      final history = await historyRepository.getHistory(
        event.userId,
        event.startDate,
        event.endDate,
      );
      emit(HistoryLoaded(history: history));
    } catch (e) {
      emit(HistoryError(message: e.toString()));
    }
  }
}