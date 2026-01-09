import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:presupresto/blocs/Category/category_bloc.dart';
import 'package:presupresto/blocs/Category/category_state.dart';
import 'package:presupresto/models/category.dart';
import 'package:presupresto/models/transaction.dart';

class TransactionModalCreateWidget extends StatefulWidget {
  List<Category> categories = [];
  final Function(Transaction) onSave;

  TransactionModalCreateWidget({super.key, required this.onSave});

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

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    amountController = TextEditingController();
    selectedCategory = '';
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
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción')),
            TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number),
            SizedBox(height: 20),
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
          onPressed: () {
            widget.onSave(Transaction(
              title: titleController.text,
              description: descriptionController.text,
              amount: double.parse(amountController.text),
              category: widget.categories.firstWhere(
                  (cat) => cat.id == selectedCategory,
                  orElse: () => Category(
                      id: '', name: '', description: '', color: '', icon: '')),
              date: selectedDate,
              id: '',
              type: 'expense',
            ));
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
          return DropdownButton<String>(
            value: selectedCategory!.isEmpty ? null : selectedCategory,
            hint: const Text('Selecciona una categoría'),
            items: state.items.map((Category category) {
              return DropdownMenuItem<String>(
                value: category.id.toString(),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Color(int.parse(
                                category.color!.replaceAll('#', '0xFF'))),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons
                                  .solidCircle, // Placeholder for icon
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(category.name),
                      ],
                    ),
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
