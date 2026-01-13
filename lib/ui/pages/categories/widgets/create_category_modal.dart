import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:presupresto/models/category.dart';
import 'package:presupresto/models/user.dart';
import 'package:presupresto/ui/pages/categories/widgets/dropdown_selected_color.dart';
import 'package:presupresto/ui/pages/categories/widgets/dropdown_selected_icon.dart';

class CreateCategoryModal extends StatefulWidget {
  List<Category> categories = [];
  Category? categoryToUpdate;
  final Function(Category?)? onSave;
  final Function(Category?)? onUpdate;

  CreateCategoryModal(
      {super.key, this.onSave, this.onUpdate, this.categoryToUpdate});

  @override
  State<CreateCategoryModal> createState() => CreateCategoryModalState();
}

class CreateCategoryModalState extends State<CreateCategoryModal> {
  late TextEditingController titleController,
      descriptionController,
      amountController;

  MaterialColor selectedColor = Colors.grey;
  String selectedColorCode = '#9E9E9E';
  String? selectedIcon;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  User? currentUser;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    if (widget.categoryToUpdate != null) {
      titleController.text = widget.categoryToUpdate!.name;
      descriptionController.text = widget.categoryToUpdate!.description!;
      selectedColorCode = widget.categoryToUpdate!.color!;
      selectedIcon = widget.categoryToUpdate!.icon;
    }
  }

  @override
  Widget build(BuildContext context) {
    var alertDialog = AlertDialog(
      title: const Text('Nueva Categoría'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título')),
            TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción')),
            const SizedBox(height: 20),
            DropdownSelectedColor(
              onColorSelected: (MaterialColor color, String colorCode) {
                setState(() {
                  selectedColor = color;
                  selectedColorCode = colorCode;
                });
              },
            ),
            DropdownSelectedIcon(
              onIconSelected: (String icon) {
                setState(() {
                  selectedIcon = icon;
                });
              },
            ),
            const SizedBox(height: 20),
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
            if (widget.categoryToUpdate != null) {
              widget.onUpdate!(Category(
                userId: currentUser != null ? currentUser!.id : '',
                name: titleController.text,
                description: descriptionController.text,
                color: selectedColorCode,
                icon: selectedIcon ?? '',
                id: widget.categoryToUpdate!.id,
                categoryId: widget.categoryToUpdate!.id,
              ));
            } else {
              widget.onSave?.call(Category(
                userId: currentUser != null ? currentUser!.id.toString() : '',
                name: titleController.text,
                description: descriptionController.text,
                color: selectedColorCode,
                icon: selectedIcon ?? '',
                id: '',
                categoryId: '',
              ));
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
    return alertDialog;
  }
}
