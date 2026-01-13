import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:presupresto/blocs/Category/category_bloc.dart';
import 'package:presupresto/blocs/Category/category_state.dart';
import 'package:presupresto/models/category.dart';
import 'package:presupresto/models/transaction.dart';
import 'package:presupresto/models/user.dart';
import 'package:presupresto/utils/icon_helper.dart';

class TransactionModalCreateWidget extends StatefulWidget {
  List<Category> categories = [];
  Transaction? transactionToUpdate;
  final Function(Transaction)? onSave;
  final Function(Transaction)? onUpdate;

  TransactionModalCreateWidget(
      {super.key, this.onSave, this.onUpdate, this.transactionToUpdate});

  @override
  State<TransactionModalCreateWidget> createState() =>
      TransactionModalCreateWidgetState();
}

class TransactionModalCreateWidgetState
    extends State<TransactionModalCreateWidget> {
  late TextEditingController titleController,
      descriptionController,
      amountController;
  DateTime selectedDate = DateTime.now();
  String? selectedCategory;

  MaterialColor selectedColor = Colors.grey;
  String selectedColorCode = '#9E9E9E';
  String? selectedIcon;
  String? selectedTypeTransaction = 'expense';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  User? currentUser;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    amountController = TextEditingController();
    selectedCategory = '';
    selectedTypeTransaction = 'expense'; // Valor por defecto
    if (widget.transactionToUpdate != null) {
      titleController.text = widget.transactionToUpdate!.title;
      descriptionController.text = widget.transactionToUpdate!.description;
      amountController.text = widget.transactionToUpdate!.amount.toString();
      selectedDate = widget.transactionToUpdate!.date;
      selectedCategory = widget.transactionToUpdate!.category.id;
      selectedTypeTransaction = widget.transactionToUpdate!.type;
    }
  }

  @override
  Widget build(BuildContext context) {
    var alertDialog = AlertDialog(
      title: const Text('Nueva Transacción'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedTypeTransaction,
              hint: const Text('Selecciona tipo'),
              items: const [
                DropdownMenuItem(
                  value: 'income',
                  child: Text('Ingreso'),
                ),
                DropdownMenuItem(
                  value: 'expense',
                  child: Text('Gasto'),
                ),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  selectedTypeTransaction = newValue;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título')),
            TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción')),
            TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            _dropDownCategories(),
            TextButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
              child: Text(
                  'Fecha: ${DateFormat('dd/MM/yyyy').format(selectedDate)}'),
            ),
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
            if (widget.transactionToUpdate != null) {
              widget.onUpdate!(Transaction(
                userId: currentUser != null ? currentUser!.id : '',
                title: titleController.text,
                description: descriptionController.text,
                amount: double.parse(amountController.text),
                category: widget.categories.firstWhere(
                    (cat) => cat.id == selectedCategory,
                    orElse: () => Category(
                        userId: '',
                        categoryId: '',
                        id: '',
                        name: '',
                        description: '',
                        color: '',
                        icon: '')),
                date: selectedDate,
                id: widget.transactionToUpdate != null
                    ? widget.transactionToUpdate!.id
                    : '',
                type: widget.transactionToUpdate != null
                    ? widget.transactionToUpdate!.type
                    : selectedTypeTransaction!,
              ));
            } else {
              widget.onSave?.call(Transaction(
                userId: currentUser != null ? currentUser!.id.toString() : '',
                title: titleController.text,
                description: descriptionController.text,
                amount: double.parse(amountController.text),
                category: widget.categories.firstWhere(
                    (cat) => cat.id == selectedCategory,
                    orElse: () => Category(
                        userId: '',
                        categoryId: '',
                        id: '',
                        name: '',
                        description: '',
                        color: '',
                        icon: '')),
                date: selectedDate,
                id: '',
                type: selectedTypeTransaction!,
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
          if (widget.transactionToUpdate != null &&
              (selectedCategory == null || selectedCategory!.isEmpty)) {
            final categoryId = widget.transactionToUpdate!.category.id;
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
