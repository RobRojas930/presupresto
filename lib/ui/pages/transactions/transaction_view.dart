import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
import 'package:presupresto/models/user.dart';
import 'package:presupresto/repositories/category_repository.dart';
import 'package:presupresto/repositories/transaction_repository.dart';
import 'package:presupresto/services/category_service.dart';
import 'package:presupresto/services/transaction_service.dart';
import 'package:presupresto/ui/pages/transactions/widgets/transaction_card_widget.dart';
import 'package:presupresto/ui/pages/transactions/widgets/transaction_modal_create_widget.dart';
import 'package:presupresto/utils/constants.dart';

// ignore: must_be_immutable
class TransactionView extends StatefulWidget {
  List<Transaction> transactions = [];
  TransactionView({super.key});

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  DateTime selectedDate = DateTime.now();
  TextEditingController searchController = TextEditingController();
  TransactionService transactionService =
      TransactionService(baseUrl: AppConstants.baseUrl);
  User? currentUser;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? selectedTitleTransaction = '';
  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _showTransactionModal(BuildContext context) {
    final categoryBloc = context.read<CategoryBloc>();

    showDialog(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => BlocProvider.value(
        value: categoryBloc,
        child: TransactionModalCreateWidget(
          onSave: (Transaction transaction) {
            context.read<TransactionBloc>().add(AddTransaction(
                transaction,
                DateTime(selectedDate.year, selectedDate.month, 1),
                DateTime(selectedDate.year, selectedDate.month + 1, 0)));
            Navigator.of(dialogContext).pop();
          },
        ),
      ),
    );
  }

  void _previousMonth(BuildContext context) {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month - 1);
      context.read<TransactionBloc>().add(LoadTransactions(
          userId: (currentUser?.id as String?) ?? '',
          startDate: DateTime(selectedDate.year, selectedDate.month, 1),
          endDate: DateTime(selectedDate.year, selectedDate.month + 1, 0)));
    });
  }

  void _nextMonth(BuildContext context) {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + 1);
      context.read<TransactionBloc>().add(LoadTransactions(
          userId: (currentUser?.id as String?) ?? '',
          startDate: DateTime(selectedDate.year, selectedDate.month, 1),
          endDate: DateTime(selectedDate.year, selectedDate.month + 1, 0)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TransactionBloc>(
          create: (_) => TransactionBloc(TransactionRepository(
              service: TransactionService(baseUrl: AppConstants.baseUrl)))
            ..add(LoadTransactions(
                userId: (currentUser?.id as String?) ?? '',
                startDate: DateTime(selectedDate.year, selectedDate.month, 1),
                endDate:
                    DateTime(selectedDate.year, selectedDate.month + 1, 0))),
        ),
        BlocProvider<CategoryBloc>(
          create: (_) => CategoryBloc(CategoryRepository(
              service: CategoryService(baseUrl: AppConstants.baseUrl)))
            ..add(LoadCategories()),
        ),
      ],
      child: Builder(
        builder: (context) => _main(context),
      ),
    );
  }

  Scaffold _main(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top Row: Button + Search Bar
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _showTransactionModal(context),
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
                    onChanged: (value) {
                      // Implement search functionality if needed
                      setState(() {
                        selectedTitleTransaction = value;
                      });
                    },
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

                    final filteredTransactions =
                        selectedTitleTransaction == null ||
                                selectedTitleTransaction!.isEmpty
                            ? transactions
                            : transactions
                                .where((tx) => tx.title.toLowerCase().contains(
                                    selectedTitleTransaction!.toLowerCase()))
                                .toList();

                    return ListView.builder(
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = filteredTransactions[index];
                        return TransactionCardWidget(
                          transaction: transaction as Transaction,
                          startDate: DateTime(
                              selectedDate.year, selectedDate.month, 1),
                          endDate: DateTime(
                              selectedDate.year, selectedDate.month + 1, 0),
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

  void _loadCurrentUser() async {
    final user = await _storage.read(key: 'user');
    if (user != null) {
      currentUser = User.fromJson(jsonDecode(user));
    }
  }
}
