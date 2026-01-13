import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:presupresto/blocs/Category/category_bloc.dart';
import 'package:presupresto/blocs/Category/category_event.dart';
import 'package:presupresto/models/category.dart';
import 'package:presupresto/ui/pages/categories/widgets/category_card_widget.dart';
import 'package:presupresto/ui/pages/categories/widgets/create_category_modal.dart';
import 'package:presupresto/utils/icon_helper.dart';

class CategoryCardWidget extends StatelessWidget {
  final Category? category;
  final DateTime startDate;
  final DateTime endDate;
  final Function(Category Category) deleteCategories;

  const CategoryCardWidget(
      {required this.category,
      required this.startDate,
      required this.endDate,
      required this.deleteCategories});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(
                      int.parse(category!.color!.replaceAll('#', '0xFF'))),
                  shape: BoxShape.circle,
                ),
                child: Center(
                    child: FaIcon(
                  IconHelper.getIcon(category!.icon ?? ''),
                  size: 30,
                  color: Colors.white,
                ))),
            const SizedBox(width: 50),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category!.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(category!.description!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showCategoryModal(context),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Eliminar'),
                    content: const Text('¿Eliminar categoria?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text('Cancelar')),
                      TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: const Text('Eliminar')),
                    ],
                  ),
                );
                if (confirm != true) return;
                deleteCategories(category!);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryModal(BuildContext context) {
    final categoryBloc = context.read<CategoryBloc>();

    showDialog(
      context: context,
      useRootNavigator: false, // <-- clave

      builder: (dialogContext) => BlocProvider.value(
        value: categoryBloc, // reusa la instancia existente
        child: CreateCategoryModal(
          categoryToUpdate: category,
          onUpdate: (Category? category) {
            _updateCategory(context, category!);

            Navigator.of(dialogContext).pop();
          },
        ),
      ),
    );
  }

  void _updateCategory(BuildContext context, Category category) {
    context.read<CategoryBloc>().add(UpdateCategory(category));
  }
}
