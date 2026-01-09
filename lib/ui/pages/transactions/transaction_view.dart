import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presupresto/blocs/Category/category_bloc.dart';
import 'package:presupresto/blocs/Category/category_event.dart';
import 'package:presupresto/blocs/Category/category_state.dart';

import 'package:presupresto/blocs/Transaction/transaction_bloc.dart';
import 'package:presupresto/blocs/Transaction/transaction_event.dart';
import 'package:presupresto/blocs/Transaction/transaction_state.dart';
import 'package:presupresto/models/transaction.dart';
import 'package:presupresto/models/category.dart';
import 'package:presupresto/repositories/category_repository.dart';
import 'package:presupresto/repositories/transaction_repository.dart';
import 'package:presupresto/services/category_service.dart';
import 'package:presupresto/services/transaction_service.dart';
import 'package:presupresto/ui/pages/transactions/widgets/transaction_card_widget.dart';
import 'package:presupresto/ui/pages/transactions/widgets/transaction_modal_create_widget.dart';
import 'package:presupresto/utils/constants.dart';

class TransactionView extends StatelessWidget {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TransactionBloc>(
          create: (_) => TransactionBloc(TransactionRepository(
              service: TransactionService(baseUrl: AppConstants.baseUrl)))
            ..add(LoadTransactions()),
        ),
        BlocProvider<CategoryBloc>(
          create: (_) => CategoryBloc(CategoryRepository(
              service: CategoryService(baseUrl: AppConstants.baseUrl)))
            ..add(LoadCategories()),
        ),
      ],
      child: TransactionViewWidget(),
    );
  }
}

class TransactionViewWidget extends StatefulWidget {
  List<Transaction> transactions = [];
  TransactionViewWidget({Key? key}) : super(key: key);

  @override
  State<TransactionViewWidget> createState() => _TransactionViewWidgetState();
}

class _TransactionViewWidgetState extends State<TransactionViewWidget> {
  DateTime selectedDate = DateTime.now();
  TextEditingController searchController = TextEditingController();
  TransactionService transactionService =
      TransactionService(baseUrl: AppConstants.baseUrl);

  void _showTransactionModal() {
    final categoryBloc = context.read<CategoryBloc>();

    showDialog(
      context: context,
      useRootNavigator: false, // <-- clave

      builder: (dialogContext) => BlocProvider.value(
        value: categoryBloc, // reusa la instancia existente
        child: TransactionModalCreateWidget(
          onSave: (Transaction transaction) {
            _addTransaction(transaction);
            Navigator.of(dialogContext).pop();
          },
        ),
      ),
    );
  }

  void _addTransaction(Transaction transaction) {
    context.read<TransactionBloc>().add(AddTransaction(transaction));
  }

  void _previousMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top Row: Button + Search Bar
            Row(
              children: [
                ElevatedButton(
                  onPressed: _showTransactionModal,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(Icons.add, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      suffixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Calendar Controller
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_left),
                  onPressed: _previousMonth,
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
                  onPressed: _nextMonth,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Transactions List
            Expanded(
              child: BlocBuilder<TransactionBloc, TransactionState>(
                builder: (context, state) {
                  if (state is TransactionLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TransactionLoaded) {
                    final transactions = state.props[0] as List<Transaction>;
                    if (transactions.isEmpty) {
                      return const Center(child: Text('No hay transacciones'));
                    }
                    return ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return TransactionCardWidget(
                          transaction: transaction as Transaction,
                          deleteTransactions: (tx) {
                            context
                                .read<TransactionBloc>()
                                .add(DeleteTransaction(tx.id));
                          },
                        );
                      },
                    );
                  } else {
                    return const Center(
                        child: Text('No hay transacciones para mostrar'));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
