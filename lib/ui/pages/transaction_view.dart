import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({Key? key}) : super(key: key);

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  DateTime selectedDate = DateTime.now();
  TextEditingController searchController = TextEditingController();
  List<Transaction> transactions = [];

  final List<String> categories = ['Comida', 'Transporte', 'Entretenimiento', 'Salud', 'Otros'];

  void _showTransactionModal() {
    showDialog(
      context: context,
      builder: (context) => _TransactionModal(categories: categories, onSave: _addTransaction),
    );
  }

  void _addTransaction(Transaction transaction) {
    setState(() {
      transactions.add(transaction);
    });
    Navigator.pop(context);
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return _TransactionCard(transaction: transaction);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const _TransactionCard({required this.transaction});

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
                  Text(transaction.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(transaction.description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                transaction.category,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('\$${transaction.amount}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(DateFormat('dd/MM/yy').format(transaction.date), style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionModal extends StatefulWidget {
  final List<String> categories;
  final Function(Transaction) onSave;

  const _TransactionModal({required this.categories, required this.onSave});

  @override
  State<_TransactionModal> createState() => _TransactionModalState();
}

class _TransactionModalState extends State<_TransactionModal> {
  late TextEditingController titleController, descriptionController, amountController;
  DateTime selectedDate = DateTime.now();
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    amountController = TextEditingController();
    selectedCategory = widget.categories.first;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nueva Transacción'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Título')),
            TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Descripción')),
            TextField(controller: amountController, decoration: const InputDecoration(labelText: 'Monto'), keyboardType: TextInputType.number),
            DropdownButton<String>(
              value: selectedCategory,
              items: widget.categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
              onChanged: (value) => setState(() => selectedCategory = value),
            ),
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
              child: Text('Fecha: ${DateFormat('dd/MM/yyyy').format(selectedDate)}'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        TextButton(
          onPressed: () {
            widget.onSave(Transaction(
              title: titleController.text,
              description: descriptionController.text,
              amount: amountController.text,
              category: selectedCategory!,
              date: selectedDate,
            ));
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

class Transaction {
  final String title, description, amount, category;
  final DateTime date;

  Transaction({required this.title, required this.description, required this.amount, required this.category, required this.date});
}