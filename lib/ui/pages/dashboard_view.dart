import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  DateTime selectedMonth = DateTime.now();

  void _previousMonth() {
    setState(() {
      selectedMonth = DateTime(selectedMonth.year, selectedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      selectedMonth = DateTime(selectedMonth.year, selectedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Month Selector
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_left),
                    onPressed: _previousMonth,
                  ),
                  Text(
                    '${selectedMonth.month}/${selectedMonth.year}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right),
                    onPressed: _nextMonth,
                  ),
                ],
              ),
            ),
            // Summary Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSummaryCard('Gastos', '\$2,500', Colors.red),
                  _buildSummaryCard('Ingresos', '\$5,000', Colors.green),
                  _buildSummaryCard('Ahorro Neto', '\$2,500', Colors.blue),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Categories Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Categorías',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildCategoryCard(
                      'Alimentación', '\$450', 0.6, Colors.orange),
                  _buildCategoryCard('Transporte', '\$300', 0.4, Colors.purple),
                  _buildCategoryCard(
                      'Entretenimiento', '\$250', 0.33, Colors.pink),
                  _buildCategoryCard('Servicios', '\$500', 0.67, Colors.teal),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String amount, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(title, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 8),
              Text(amount,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
      String category, String amount, double progress, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(category,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(amount,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
