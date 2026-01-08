import 'package:flutter/material.dart';
import 'package:presupresto/ui/pages/budget_view.dart';
import 'package:presupresto/ui/pages/dashboard_view.dart';
import 'package:presupresto/ui/pages/history_view.dart';
import 'package:presupresto/ui/pages/transaction_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardView(),
    const TransactionView(),
    const BudgetView(),
    const HistoryView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presupuesto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: Colors.green[800],
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Transacciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Presupuestos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Histórico',
          ),
        ],
      ),
    );
  }
}
