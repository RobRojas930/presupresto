import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:presupresto/blocs/Category/category_bloc.dart';
import 'package:presupresto/blocs/Category/category_state.dart';
import 'package:presupresto/models/budget.dart';
import 'package:presupresto/models/category.dart';
import 'package:presupresto/models/transaction.dart';
import 'package:presupresto/models/user.dart';
import 'package:presupresto/utils/icon_helper.dart';

class BudgetModalCreateWidget extends StatefulWidget {
  List<Category> categories = [];
  Budget? budgetToUpdate;
  final Function(Budget)? onSave;
  final Function(Budget)? onUpdate;

  BudgetModalCreateWidget(
      {super.key, this.onSave, this.onUpdate, this.budgetToUpdate});
  @override
  State<BudgetModalCreateWidget> createState() =>
      BudgetModalCreateWidgetState();
}

class BudgetModalCreateWidgetState extends State<BudgetModalCreateWidget> {
  late TextEditingController titleController, initialAmountController;
  DateTime selectedDate = DateTime.now();
  String? selectedCategory;

  MaterialColor selectedColor = Colors.grey;
  String selectedColorCode = '#9E9E9E';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  User? currentUser;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    initialAmountController = TextEditingController();
    selectedCategory = '';
    if (widget.budgetToUpdate != null) {
      titleController.text = widget.budgetToUpdate!.title;
      initialAmountController.text =
          widget.budgetToUpdate!.initialAmount.toString();
      selectedCategory = widget.budgetToUpdate!.categoryId;
    }
  }

  @override
  Widget build(BuildContext context) {
    var alertDialog = AlertDialog(
      title: const Text('Nueva Transacción'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título')),
            TextField(
                controller: initialAmountController,
                decoration: const InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            _dropDownCategories(),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar')),
        TextButton(
          onPressed: () async {
            final user = await _storage.read(key: 'user');
            if (user != null) {
              currentUser = User.fromJson(jsonDecode(user));
            }
            if (widget.budgetToUpdate != null) {
              widget.onUpdate!(Budget(
                  userId: currentUser != null ? currentUser!.id : '',
                  title: titleController.text,
                  initialAmount: double.parse(initialAmountController.text),
                  categoryId: selectedCategory!,
                  color: widget.categories
                      .firstWhere((cat) => cat.id == selectedCategory,
                          orElse: () => Category(
                              id: '',
                              name: '',
                              icon: '',
                              color: '#9E9E9E',
                              categoryId: '',
                              description: ''))
                      .color!,
                  id: widget.budgetToUpdate!.id,
                  currentAmount: 0.0,
                  percentage: 0.0));
            } else {
              widget.onSave?.call(Budget(
                userId: currentUser != null ? currentUser!.id.toString() : '',
                title: titleController.text,
                initialAmount: double.parse(initialAmountController.text),
                categoryId: selectedCategory!,
                id: '',
                currentAmount: 0.0,
                percentage: 0.0,
                color: selectedColorCode,
              ));
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
    return alertDialog;
  }

  BlocBuilder<CategoryBloc, CategoryState> _dropDownCategories() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoaded) {
          widget.categories = state.items;

          // Crear lista de IDs válidos
          final validIds = state.items.map((c) => c.id).toSet();

          // Si estamos editando y aún no se ha seleccionado, asignar la categoría
          if (widget.budgetToUpdate != null &&
              (selectedCategory == null || selectedCategory!.isEmpty)) {
            final categoryId = widget.budgetToUpdate!.categoryId;
            if (validIds.contains(categoryId)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    selectedCategory = categoryId;
                  });
                }
              });
            }
          }

          // Validar que el valor seleccionado existe en los items
          final valueToShow = (selectedCategory != null &&
                  selectedCategory!.isNotEmpty &&
                  validIds.contains(selectedCategory))
              ? selectedCategory
              : null;

          return DropdownButton<String>(
            value: valueToShow,
            hint: const Text('Selecciona una categoría'),
            items: state.items.map((Category category) {
              return DropdownMenuItem<String>(
                value: category.id,
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Color(
                            int.parse(category.color!.replaceAll('#', '0xFF'))),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                          child: FaIcon(
                        IconHelper.getIcon(category.icon ?? ''),
                        size: 12,
                        color: Colors.white,
                      )),
                    ),
                    SizedBox(width: 10),
                    Text(category.name),
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedCategory = newValue;
              });
            },
          );
        } else if (state is CategoryLoading) {
          return const CircularProgressIndicator();
        } else {
          return const Text('No se pudieron cargar las categorías');
        }
      },
    );
  }
}
