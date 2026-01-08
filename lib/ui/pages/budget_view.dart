import 'package:flutter/material.dart';

class BudgetView extends StatelessWidget {
  const BudgetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presupuestos'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BudgetCard(
            title: 'Alimentación',
            spent: 450,
            total: 600,
            category: 'Food',
            categoryColor: Colors.green,
          ),
          BudgetCard(
            title: 'Transporte',
            spent: 120,
            total: 150,
            category: 'Transport',
            categoryColor: Colors.blue,
          ),
          BudgetCard(
            title: 'Entretenimiento',
            spent: 80,
            total: 100,
            category: 'Entertainment',
            categoryColor: Colors.purple,
          ),
        ],
      ),
    );
  }
}

class BudgetCard extends StatelessWidget {
  final String title;
  final double spent;
  final double total;
  final String category;
  final Color categoryColor;

  const BudgetCard({
    Key? key,
    required this.title,
    required this.spent,
    required this.total,
    required this.category,
    required this.categoryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double percentage = spent / total;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 8,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(categoryColor),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${spent.toStringAsFixed(2)} / \$${total.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}