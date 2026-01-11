import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:presupresto/blocs/budget/budget_event.dart';
import 'package:presupresto/blocs/budget/budget_state.dart';
import '../../models/budget.dart';
import '../../repositories/budget_repository.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final BudgetRepository budgetRepository;

  BudgetBloc({required this.budgetRepository}) : super(BudgetInitial()) {
    on<LoadBudgets>(_onLoadBudgets);
    on<AddBudget>(_onAddBudget);
    on<UpdateBudget>(_onUpdateBudget);
    on<DeleteBudget>(_onDeleteBudget);
  }

  Future<void> _onLoadBudgets(
    LoadBudgets event,
    Emitter<BudgetState> emit,
  ) async {
    emit(BudgetLoading());
    try {
      final budgets = await budgetRepository.getBudgetData('', {
        'userId': event.userId,
        'startDate': event.startDate,
        'endDate': event.endDate,
      });
      emit(BudgetLoaded(
        budgets,
      ));
    } catch (e) {
      emit(BudgetError(e.toString()));
    }
  }

  Future<void> _onAddBudget(
    AddBudget event,
    Emitter<BudgetState> emit,
  ) async {
    emit(BudgetLoading());
    try {
      await budgetRepository.createBudget(event.budget);
      final budgets = await budgetRepository.getBudgetData(
        '',
        {
          'userId': event.userId,
          'startDate': event.startDate,
          'endDate': event.endDate,
        },
      );
      emit(BudgetLoaded(
        budgets,
      ));
    } catch (e) {
      emit(BudgetError(e.toString()));
    }
  }

  Future<void> _onUpdateBudget(
    UpdateBudget event,
    Emitter<BudgetState> emit,
  ) async {
    emit(BudgetLoading());
    try {
      await budgetRepository.updateBudget(event.budget.id, event.budget);
      final budgets = await budgetRepository.getBudgetData(
        '',
        {
          'userId': event.userId,
          'startDate': event.startDate,
          'endDate': event.endDate,
        },
      );
      emit(BudgetLoaded(
        budgets,
      ));
    } catch (e) {
      emit(BudgetError(e.toString()));
    }
  }

  Future<void> _onDeleteBudget(
    DeleteBudget event,
    Emitter<BudgetState> emit,
  ) async {
    emit(BudgetLoading());
    try {
      await budgetRepository.deleteBudget(event.budgetId);
      final budgets = await budgetRepository.getBudgetData(
        '',
        {
          'userId': event.userId,
          'startDate': event.startDate,
          'endDate': event.endDate,
        },
      );
      emit(BudgetLoaded(
        budgets,
      ));
    } catch (e) {
      emit(BudgetError(e.toString()));
    }
  }
}
