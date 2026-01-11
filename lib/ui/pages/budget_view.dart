import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presupresto/blocs/DashBoard/dashboard_event.dart';
import 'package:presupresto/blocs/budget/budget_bloc.dart';
import 'package:presupresto/blocs/budget/budget_event.dart';
import 'package:presupresto/blocs/budget/budget_state.dart';
import 'package:presupresto/models/budget.dart';
import 'package:presupresto/models/category.dart';
import 'package:presupresto/models/user.dart';
import 'package:presupresto/repositories/budget_repository.dart';
import 'package:presupresto/repositories/category_repository.dart';
import 'package:presupresto/services/budget_service.dart';
import 'package:presupresto/services/category_service.dart';
import 'package:presupresto/utils/constants.dart';

class BudgetView extends StatelessWidget {
  User? user;
  CategoryRepository categoryRepository = CategoryRepository(
      service: CategoryService(baseUrl: AppConstants.baseUrl));
  final DateTime selectedMonth = DateTime.now();

  BudgetView({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BudgetBloc(
        budgetRepository: BudgetRepository(
          budgetService: BudgetService(
              baseUrl: AppConstants
                  .baseUrl), // TODO: Provide the required service instance
        ),
      )..add(LoadBudgets(
          userId: user?.id ?? '',
          startDate: DateTime(selectedMonth.year, selectedMonth.month, 1),
          endDate: DateTime(selectedMonth.year, selectedMonth.month + 1, 0))),
      child: _page(context),
    );
  }

  _page(BuildContext context) {
    return BlocBuilder<BudgetBloc, BudgetState>(
      builder: (context, state) {
        if (state is BudgetLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BudgetLoaded) {
          return _content(state.budgets);
        } else if (state is BudgetError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const Center(child: Text('Estado desconocido'));
        }
      },
    );
  }

  _content(List<Budget> budgets) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presupuestos'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...budgets
              .map(
                (budget) => FutureBuilder<Category>(
                  future: categoryRepository.fetchById('', budget.categoryId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final category = snapshot.data;
                    return BudgetCard(
                      title: budget.title,
                      spent: budget.initialAmount - budget.currentAmount,
                      total: budget.initialAmount,
                      category: category?.name ?? 'Sin categoría',
                      categoryColor: Color(int.parse(
                          category?.color?.replaceAll('#', '0xFF') ??
                              '0xFF9E9E9E')),
                      budgetColor: Color(
                          int.parse(budget.color.replaceAll('#', '0xFF'))),
                    );
                  },
                ),
              )
              .toList()
        ],
      ),
    );
  }
}

class BudgetCard extends StatelessWidget {
  final String title;
  final double spent;
  final double total;
  final String category;
  final Color categoryColor;
  final Color budgetColor;

  const BudgetCard({
    Key? key,
    required this.title,
    required this.spent,
    required this.total,
    required this.category,
    required this.budgetColor,
    required this.categoryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double percentage = spent / total;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 8,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(budgetColor),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${spent.toStringAsFixed(2)} / \$${total.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
