import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:presupresto/blocs/DashBoard/dashboard_event.dart';
import 'package:presupresto/blocs/DashBoard/dashboard_state.dart';
import 'package:presupresto/repositories/dashboard_repository.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _repository;

  DashboardBloc({required DashboardRepository repository})
      : _repository = repository,
        super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
    on<RefreshDashboardData>(_onRefreshDashboardData);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final dashboard = await _repository.getDashboardData('', {
        'userId': event.userId,
        'startDate': event.startDate.toIso8601String(),
        'endDate': event.endDate.toIso8601String(),
      });
      emit(DashboardLoaded(dashboard: dashboard));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

  Future<void> _onRefreshDashboardData(
    RefreshDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final dashboard = await _repository.getDashboardData('', {
        'userId': event.userId,
        'startDate': event.startDate.toIso8601String(),
        'endDate': event.endDate.toIso8601String(),
      });
      emit(DashboardLoaded(dashboard: dashboard));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }
}
