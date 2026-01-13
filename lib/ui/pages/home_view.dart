import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:presupresto/models/user.dart';
import 'package:presupresto/ui/pages/budgets/budget_view.dart';
import 'package:presupresto/ui/pages/categories/category_view.dart';
import 'package:presupresto/ui/pages/dashboard_view.dart';
import 'package:presupresto/ui/pages/history_view.dart';
import 'package:presupresto/ui/pages/transactions/transaction_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  User? user;
  @override
  void initState() {
    super.initState();
  }

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
      body: FutureBuilder(
        future: _getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return _selectPage(_selectedIndex, user);
          }
        },
      ),
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
            icon: Icon(Icons.category),
            label: 'Categorías',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Histórico',
          ),
        ],
      ),
    );
  }

  _selectPage(int index, User? user) {
    final List<Widget> pages = [
      DashboardView(user: user),
      TransactionView(user: user),
      BudgetView(user: user),
      CategoryView(user: user),
      HistoryView(user: user),
    ];
    return pages[index];
  }

  _getUser() async {
    final userData = await _storage.read(key: 'user');
    if (userData != null) {
      user = User.fromJson(jsonDecode(userData));
    }
  }
}
