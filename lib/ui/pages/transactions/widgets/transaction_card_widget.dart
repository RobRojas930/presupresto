import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:presupresto/models/transaction.dart';

class TransactionCardWidget extends StatelessWidget {
  final Transaction transaction;
  final Function(Transaction transaction) deleteTransactions;

  const TransactionCardWidget(
      {required this.transaction, required this.deleteTransactions});

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
                Text('\$${transaction.amount}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(DateFormat('dd/MM/yy').format(transaction.date),
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
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
}
