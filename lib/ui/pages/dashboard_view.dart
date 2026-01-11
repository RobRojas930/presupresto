import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presupresto/blocs/DashBoard/dashboard_bloc.dart';
import 'package:presupresto/blocs/DashBoard/dashboard_event.dart';
import 'package:presupresto/blocs/DashBoard/dashboard_state.dart';
import 'package:presupresto/models/dashboard.dart';
import 'package:presupresto/models/user.dart';
import 'package:presupresto/repositories/dashboard_repository.dart';
import 'package:presupresto/services/dashboard_service.dart';
import 'package:presupresto/utils/constants.dart';

class DashboardView extends StatefulWidget {
  User? user;
  DashboardView({Key? key, this.user}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  DateTime selectedMonth = DateTime.now();

  void _previousMonth(BuildContext context) {
    setState(() {
      selectedMonth = DateTime(selectedMonth.year, selectedMonth.month - 1);
      context.read<DashboardBloc>().add(LoadDashboardData(
          userId: widget.user?.id ?? '',
          startDate: DateTime(selectedMonth.year, selectedMonth.month, 1),
          endDate: DateTime(selectedMonth.year, selectedMonth.month + 1, 0)));
    });
  }

  void _nextMonth(BuildContext context) {
    setState(() {
      selectedMonth = DateTime(selectedMonth.year, selectedMonth.month + 1);
      context.read<DashboardBloc>().add(LoadDashboardData(
          userId: widget.user?.id ?? '',
          startDate: DateTime(selectedMonth.year, selectedMonth.month, 1),
          endDate: DateTime(selectedMonth.year, selectedMonth.month + 1, 0)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardBloc(
        repository: DashboardRepository(
          dashboardService: DashBoardService(
              baseUrl: AppConstants
                  .baseUrl), // TODO: Provide the required service instance
        ),
      )..add(LoadDashboardData(
          userId: widget.user?.id ?? '',
          startDate: DateTime(selectedMonth.year, selectedMonth.month, 1),
          endDate: DateTime(selectedMonth.year, selectedMonth.month + 1, 0))),
      child: _page(),
    );
  }

  Widget _page() {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DashboardLoaded) {
              return _dashboardPage(state.dashboard);
            } else if (state is DashboardError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('Seleccione un mes'));
            }
          },
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

  Widget _dashboardPage(Dashboard dashboard) {
    return Column(
      children: [
        // Month Selector
        Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_left),
                  onPressed: () => _previousMonth(context),
                ),
                Text(
                  '${selectedMonth.month}/${selectedMonth.year}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_right),
                  onPressed: () => _nextMonth(context),
                ),
              ],
            ),
          ),
        ),
        // Summary Cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSummaryCard(
                  'Gastos', '\$${dashboard.totalExpense}', Colors.red),
              _buildSummaryCard(
                  'Ingresos', '\$${dashboard.totalIncome}', Colors.green),
              _buildSummaryCard(
                  'Ahorro Neto', '\$${dashboard.totalSaved}', Colors.blue),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...dashboard.categories.map((category) => _buildCategoryCard(
                  category.category,
                  '\$${category.total}',
                  category.percentage / 100,
                  Color(int.parse(category.color.replaceAll('#', '0xFF'))))),
            ],
          ),
        ),
      ],
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
