import 'package:equatable/equatable.dart';
import 'package:presupresto/models/budget.dart';
import 'package:presupresto/models/user.dart';

abstract class BudgetEvent extends Equatable {
  const BudgetEvent();

  @override
  List<Object?> get props => [];
}

class LoadBudgets extends BudgetEvent {
  final DateTime startDate;
  final DateTime endDate;
  final String? userId;
  const LoadBudgets(
      {required this.startDate, required this.endDate, this.userId});
}

class AddBudget extends BudgetEvent {
  final Budget budget;
  final DateTime startDate;
  final DateTime endDate;
  final String? userId;
  const AddBudget(this.budget, this.startDate, this.endDate, this.userId);

  @override
  List<Object?> get props => [budget, startDate, endDate, userId];
}

class UpdateBudget extends BudgetEvent {
  final Budget budget;
  final DateTime startDate;
  final DateTime endDate;
  final String? userId;
  const UpdateBudget(this.budget, this.startDate, this.endDate, this.userId);

  @override
  List<Object?> get props => [budget, startDate, endDate, userId];
}

class DeleteBudget extends BudgetEvent {
  final String budgetId;
  final DateTime startDate;
  final DateTime endDate;
  final String? userId;
  const DeleteBudget(this.budgetId, this.startDate, this.endDate, this.userId);

  @override
  List<Object?> get props => [budgetId, startDate, endDate, userId];
}
