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
import 'package:presupresto/ui/pages/categories/widgets/category_card_widget.dart';
import 'package:presupresto/ui/pages/categories/widgets/create_category_modal.dart';
import 'package:presupresto/ui/pages/transactions/widgets/transaction_card_widget.dart';
import 'package:presupresto/ui/pages/transactions/widgets/transaction_modal_create_widget.dart';
import 'package:presupresto/utils/constants.dart';

// ignore: must_be_immutable
class CategoryView extends StatefulWidget {
  List<Transaction> transactions = [];
  User? user;
  CategoryView({super.key, this.user});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  DateTime selectedDate = DateTime.now();
  TextEditingController searchController = TextEditingController();
  TransactionService transactionService =
      TransactionService(baseUrl: AppConstants.baseUrl);
  String? selectNameCategory = '';



  @override
  void initState() {
    super.initState();
  }



  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _showCategoryModal(BuildContext context) {
    final categoryBloc = context.read<CategoryBloc>();
    showDialog(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => BlocProvider.value(
        value: categoryBloc,
        child: CreateCategoryModal(
          onSave: (Category? category) {
            categoryBloc.add(AddCategory(
                  category!,
                ));
            Navigator.of(dialogContext).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoryBloc>(
          create: (_) => CategoryBloc(CategoryRepository(
              service: CategoryService(baseUrl: AppConstants.baseUrl)))
            ..add(LoadCategories(
              userId: widget.user?.id ?? '',
            )),
        ),
        BlocProvider<CategoryBloc>(
          create: (_) => CategoryBloc(CategoryRepository(
              service: CategoryService(baseUrl: AppConstants.baseUrl)))
            ..add(LoadCategories(userId: widget.user?.id ?? '')),
        ),
      ],
      child: Builder(
        builder: (context) => _main(context),
      ),
    );
  }

  Scaffold _main(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () => _showCategoryModal(context),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top Row: Button + Search Bar
            Row(
              children: [
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
                        selectNameCategory = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            // Calendar Controller

            const SizedBox(height: 16),
            // Transactions List
            Expanded(
              child: BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CategoryLoaded) {
                    final categories = state.props[0] as List<Category>;
                    if (categories.isEmpty) {
                      return const Center(child: Text('No hay categorias'));
                    }

                    final filteredCategories = selectNameCategory == null ||
                            selectNameCategory!.isEmpty
                        ? categories
                        : categories
                            .where((tx) => tx.name
                                .toLowerCase()
                                .contains(selectNameCategory!.toLowerCase()))
                            .toList();

                    return ListView.builder(
                      itemCount: filteredCategories.length,
                      itemBuilder: (context, index) {
                        final category = filteredCategories[index];
                        return CategoryCardWidget(
                          category: category,
                          startDate: DateTime(
                              selectedDate.year, selectedDate.month, 1),
                          endDate: DateTime(
                              selectedDate.year, selectedDate.month + 1, 0),
                          deleteCategories: (category) {
                            context
                                .read<CategoryBloc>()
                                .add(DeleteCategory(category.id));
                          },
                        );
                      },
                    );
                  } else {
                    return const Center(
                        child: Text('No hay categorias para mostrar'));
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
