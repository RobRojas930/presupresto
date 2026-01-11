import 'package:presupresto/utils/constants.dart';

import '../services/budget_service.dart';
import '../models/budget.dart';

class BudgetRepository {
  final BudgetService budgetService;
  BudgetRepository({required this.budgetService});
  // Obtener todos los presupuestos
  Future<List<Budget>> getAllBudgets() async {
    return await budgetService.getBudgets();
  }

  Future<List<Budget>> getBudgetData(
      String token, Map<String, dynamic> filter) async {
    return await budgetService.getBudgetData(token, filter);
  }

  // Obtener un presupuesto por ID
  Future<Budget?> getBudgetById(String id) async {
    return await budgetService.getBudgetById(id);
  }

  // Crear un nuevo presupuesto
  Future<void> createBudget(Budget budget) async {
    await budgetService.createBudget(budget);
  }

  // Actualizar un presupuesto existente
  Future<void> updateBudget(String idBudget, Budget budget) async {
    await budgetService.updateBudget(idBudget, budget);
  }

  // Eliminar un presupuesto
  Future<void> deleteBudget(String id) async {
    await budgetService.deleteBudget(id);
  }
}
