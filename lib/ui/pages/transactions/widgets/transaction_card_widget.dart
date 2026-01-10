import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:presupresto/blocs/Category/category_bloc.dart';
import 'package:presupresto/blocs/Transaction/transaction_bloc.dart';
import 'package:presupresto/blocs/Transaction/transaction_event.dart';
import 'package:presupresto/models/transaction.dart';
import 'package:presupresto/ui/pages/transactions/widgets/transaction_modal_create_widget.dart';

class TransactionCardWidget extends StatelessWidget {
  final Transaction transaction;
  final DateTime startDate;
  final DateTime endDate;
  final Function(Transaction transaction) deleteTransactions;

  const TransactionCardWidget(
      {required this.transaction,
      required this.startDate,
      required this.endDate,
      required this.deleteTransactions});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(transaction.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(transaction.description,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color(int.parse(
                    transaction.category.color!.replaceAll('#', '0xFF'))),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                transaction.category.name,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                    transaction.type == 'income'
                        ? '+ \$${transaction.amount.toStringAsFixed(2)}'
                        : '- \$${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: transaction.type == 'income'
                            ? Colors.green
                            : Colors.red)),
                Text(DateFormat('dd/MM/yy').format(transaction.date),
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showTransactionModal(context),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Eliminar'),
                    content: const Text('¿Eliminar transacción?'),
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
                deleteTransactions(transaction);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTransactionModal(BuildContext context) {
    final categoryBloc = context.read<CategoryBloc>();

    showDialog(
      context: context,
      useRootNavigator: false, // <-- clave

      builder: (dialogContext) => BlocProvider.value(
        value: categoryBloc, // reusa la instancia existente
        child: TransactionModalCreateWidget(
          transactionToUpdate: transaction,
          onUpdate: (Transaction transaction) {
            _updateTransaction(context, transaction);
            Navigator.of(dialogContext).pop();
          },
        ),
      ),
    );
  }

  void _updateTransaction(BuildContext context, Transaction transaction) {
    context.read<TransactionBloc>().add(UpdateTransaction(transaction));
  }
}
