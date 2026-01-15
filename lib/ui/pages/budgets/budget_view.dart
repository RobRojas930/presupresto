import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:presupresto/blocs/Category/category_bloc.dart';
import 'package:presupresto/blocs/Category/category_event.dart';
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
import 'package:presupresto/ui/pages/budgets/widgets/budget_create_modal.dart';
import 'package:presupresto/utils/colors.dart';
import 'package:presupresto/utils/constants.dart';

class BudgetView extends StatefulWidget {
  User? user;

  BudgetView({super.key, this.user});

  @override
  State<BudgetView> createState() => _BudgetViewState();
}

class _BudgetViewState extends State<BudgetView> {
  CategoryRepository categoryRepository = CategoryRepository(
      service: CategoryService(baseUrl: AppConstants.baseUrl));
  final DateTime selectedMonth = DateTime.now();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BudgetBloc>(
          create: (_) => BudgetBloc(
            budgetRepository: BudgetRepository(
              budgetService: BudgetService(
                  baseUrl: AppConstants
                      .baseUrl), // TODO: Provide the required service instance
            ),
          )..add(LoadBudgets(
              userId: widget.user?.id ?? '',
              startDate: DateTime(selectedMonth.year, selectedMonth.month, 1),
              endDate:
                  DateTime(selectedMonth.year, selectedMonth.month + 1, 0))),
          child: _page(context),
        ),
        BlocProvider<CategoryBloc>(
          create: (_) => CategoryBloc(CategoryRepository(
              service: CategoryService(baseUrl: AppConstants.baseUrl)))
            ..add(LoadCategories(userId: widget.user?.id ?? '')),
        ),
      ],
      child: Builder(
        builder: (context) => _page(context),
      ),
    );
  }

  _page(BuildContext context) {
    return BlocConsumer<BudgetBloc, BudgetState>(
      listener: (context, state) {
        if (state is BudgetError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors.warning,
            content: Text(
              state.message.replaceAll('Exception:', ''),
              style: const TextStyle(color: AppColors.warningText),
            ),
          ));
        }
      },
      builder: (context, state) {
        if (state is BudgetLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BudgetLoaded) {
          return _content(state.budgets, context);
        } else {
          return const Center(child: Text('Estado desconocido'));
        }
      },
    );
  }

  void _previousMonth(BuildContext context) {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month - 1);
      context.read<BudgetBloc>().add(LoadBudgets(
          userId: widget.user?.id ?? '',
          startDate: DateTime(selectedDate.year, selectedDate.month, 1),
          endDate: DateTime(selectedDate.year, selectedDate.month + 1, 0)));
    });
  }

  void _nextMonth(BuildContext context) {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + 1);
      context.read<BudgetBloc>().add(LoadBudgets(
          userId: widget.user?.id ?? '',
          startDate: DateTime(selectedDate.year, selectedDate.month, 1),
          endDate: DateTime(selectedDate.year, selectedDate.month + 1, 0)));
    });
  }

  _content(List<Budget> budgets, BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_left),
                onPressed: () => _previousMonth(context),
              ),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
                child: Text(
                  DateFormat('MMMM yyyy').format(selectedDate),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_right),
                onPressed: () => _nextMonth(context),
              ),
            ],
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.62,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...budgets.map(
                      (budget) => FutureBuilder<Category>(
                        future:
                            categoryRepository.fetchById('', budget.categoryId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          Category? category;
                          if (snapshot.hasError) {
                            category = Category(
                                userId: '',
                                id: '',
                                name: 'Categoria general',
                                icon: 'fa-tags',
                                color: '#9E9E9E',
                                categoryId: '',
                                description: '');
                          } else {
                            category = snapshot.data;
                          }
                          
                          return BudgetCard(
                            id: budget.id,
                            title: budget.title,
                            spent: budget.initialAmount - budget.currentAmount,
                            total: budget.initialAmount,
                            category: category?.name ?? 'Categoria general',
                            categoryColor: Color(int.parse(
                                category?.color?.replaceAll('#', '0xFF') ??
                                    '0xFF9E9E9E')),
                            budgetColor: Color(int.parse(
                                budget.color.replaceAll('#', '0xFF'))),
                            onEdit: (id) {
                              // TODO: Implementar lógica de edición
                              _showTransactionModalEdit(
                                  context,
                                  widget.user?.id ?? '',
                                  Budget(
                                    id: id,
                                    title: budget.title,
                                    initialAmount: budget.initialAmount,
                                    currentAmount: budget.currentAmount,
                                    categoryId: budget.categoryId,
                                    color: budget.color,
                                    percentage: 0.0,
                                    userId: widget.user?.id ?? '',
                                  ));
                            },
                            onDelete: (id) async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Eliminar'),
                                  content: const Text('¿Eliminar transacción?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(false),
                                        child: const Text('Cancelar')),
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(true),
                                        child: const Text('Eliminar')),
                                  ],
                                ),
                              );
                              if (confirm != true) return;
                              context.read<BudgetBloc>().add(DeleteBudget(
                                    id,
                                    DateTime(selectedDate.year,
                                        selectedDate.month, 1),
                                    DateTime(selectedDate.year,
                                        selectedDate.month + 1, 0),
                                    widget.user?.id ?? '',
                                  ));
                            },
                            selectedDate: selectedDate,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )),
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => _showTransactionModal(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.all(16),
              ),
              child: const Icon(Icons.add, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  void _showTransactionModal(BuildContext context) {
    final categoryBloc = context.read<CategoryBloc>();

    showDialog(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => BlocProvider.value(
        value: categoryBloc,
        child: BudgetModalCreateWidget(
          onSave: (Budget budget) {
            context.read<BudgetBloc>().add(AddBudget(
                  budget,
                  DateTime(selectedDate.year, selectedDate.month, 1),
                  DateTime(selectedDate.year, selectedDate.month + 1, 0),
                  widget.user?.id ?? '',
                ));
            Navigator.of(dialogContext).pop();
          },
        ),
      ),
    );
  }

  void _showTransactionModalEdit(
      BuildContext context, String userId, Budget budget) {
    final categoryBloc = context.read<CategoryBloc>();

    showDialog(
      context: context,
      useRootNavigator: false, // <-- clave

      builder: (dialogContext) => BlocProvider.value(
        value: categoryBloc, // reusa la instancia existente
        child: BudgetModalCreateWidget(
          budgetToUpdate: budget,
          onUpdate: (Budget budget) {
            _updateTransaction(context, budget);
            Navigator.of(dialogContext).pop();
          },
        ),
      ),
    );
  }

  void _updateTransaction(BuildContext context, Budget budget) {
    context.read<BudgetBloc>().add(UpdateBudget(
        budget,
        DateTime(selectedDate.year, selectedDate.month, 1),
        DateTime(selectedDate.year, selectedDate.month + 1, 0),
        budget.userId));
  }
}

class BudgetCard extends StatelessWidget {
  final String id;
  final String title;
  final double spent;
  final double total;
  final String category;
  final Color categoryColor;
  final Color budgetColor;
  final DateTime selectedDate;
  final Function(String id)? onEdit;
  final Function(String id)? onDelete;

  const BudgetCard({
    Key? key,
    required this.id,
    required this.title,
    required this.spent,
    required this.total,
    required this.category,
    required this.budgetColor,
    required this.categoryColor,
    required this.selectedDate,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double percentage = spent / total;
    return Slidable(
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                if (onEdit != null) {
                  onEdit!(id);
                }
              },
              foregroundColor: Colors.blue,
              icon: Icons.edit,
              label: 'Editar',
            ),
            SlidableAction(
              onPressed: (context) {
                if (onDelete != null) {
                  onDelete!(id);
                }
              },
              foregroundColor: Colors.red,
              icon: Icons.edit,
              label: 'Eliminar',
            )
          ],
        ),
        child: _card(percentage));
  }

  _card(double percentage) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: percentage < 0.8
              ? Colors.transparent
              : percentage > 0.8
                  ? Colors.red
                  : Colors.transparent, // o el color que prefieras
          width: 2,
        ),
      ),
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
                valueColor: AlwaysStoppedAnimation<Color>(
                  percentage < 0.8
                      ? budgetColor
                      : percentage > 0.8
                          ? Colors.red
                          : Colors
                              .transparent, // Cambia el color según el porcentaje
                ),
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
