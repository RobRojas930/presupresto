import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:presupresto/blocs/History/history_bloc.dart';
import 'package:presupresto/blocs/History/history_event.dart';
import 'package:presupresto/blocs/History/history_state.dart';
import 'package:presupresto/models/History.dart';
import 'package:presupresto/models/user.dart';
import 'package:presupresto/repositories/history_repository.dart';
import 'package:presupresto/services/history_service.dart';
import 'package:presupresto/utils/colors.dart';
import 'package:presupresto/utils/constants.dart';

// ignore: must_be_immutable
class HistoryView extends StatefulWidget {
  User? user;
  HistoryView({super.key, this.user});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  int touchedIndex = 0;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HistoryBloc>(
      create: (context) => HistoryBloc(
          historyRepository: HistoryRepository(
              historyService: HistoryService(baseUrl: AppConstants.baseUrl)))
        ..add(LoadHistoryData(
            userId: widget.user!.id,
            startDate: DateTime(selectedDate.year, selectedDate.month, 1),
            endDate: DateTime(selectedDate.year, selectedDate.month + 1, 0))),
      child: BlocConsumer<HistoryBloc, HistoryState>(
        listener: (context, state) {
          if (state is HistoryError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppColors.warning,
              content: Text(
                state.message.replaceAll('Exception:', ''),
                style: const TextStyle(color: AppColors.warningText),
              ),
            ));
          }
        },
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HistoryLoaded) {
            return _page(state.history);
          } else {
            return const Center(child: Text('Iniciando...'));
          }
        },
      ),
    );
  }

  void _previousMonth(BuildContext context) {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month - 1);
      context.read<HistoryBloc>().add(LoadHistoryData(
          userId: widget.user?.id ?? '',
          startDate: DateTime(selectedDate.year, selectedDate.month, 1),
          endDate: DateTime(selectedDate.year, selectedDate.month + 1, 0)));
    });
  }

  void _nextMonth(BuildContext context) {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + 1);
      context.read<HistoryBloc>().add(LoadHistoryData(
          userId: widget.user?.id ?? '',
          startDate: DateTime(selectedDate.year, selectedDate.month, 1),
          endDate: DateTime(selectedDate.year, selectedDate.month + 1, 0)));
    });
  }

  _page(History? history) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Builder(
                builder: (context) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_left),
                      onPressed: () => _previousMonth(context),
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
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_right),
                      onPressed: () => _nextMonth(context),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: ListView(
                    children: [
                      const Divider(),
                      HistoryListItem(
                        title: 'Cantidad de transacciones:',
                        subtitle: '${history?.countTransactions ?? 0}',
                      ),
                      const SizedBox(height: 15),
                      HistoryListItem(
                        title: 'Total de transacciones:',
                        subtitle: '\$${history?.totalTransactionsAmount ?? 0}',
                      ),
                      const SizedBox(height: 15),
                      HistoryListItem(
                        title: 'Cantidad de transacciones en el mes:',
                        subtitle: '${history?.countTransactionsByMonth}',
                      ),
                      const SizedBox(height: 15),
                      HistoryListItem(
                        title: 'Total de transacciones en el mes:',
                        subtitle: '\$${history?.totalTransactionsByMonth}',
                      ),
                      const SizedBox(height: 15),
                      HistoryListItem(
                        title: 'Total de gastos en el mes:',
                        subtitle: '\$${history?.totalExpenseByMonth}',
                      ),
                      const SizedBox(height: 15),
                      HistoryListItem(
                        title: 'Total de ingresos en el mes:',
                        subtitle: '\$${history?.totalIncomeByMonth}',
                      ),
                      const Divider(),
                    ],
                  )),
              if (history?.transactionsByCategory!.isNotEmpty ?? true)
                _categoriesChart(history)
              else
                const SizedBox.shrink(),
              if ((history?.totalExpenseByMonth ?? 0) > 0 ||
                  (history?.totalIncomeByMonth ?? 0) > 0)
                _expenseAmountChart(history)
              else
                const SizedBox.shrink(),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData>? _showingSections(
      List<CategorySummary> categories) {
    return List.generate(categories.length, (i) {
      final isTouched = i == touchedIndex;
      return _setSections(isTouched, categories, i);
    });
  }

  List<PieChartSectionData> _showingSectionsExpenseIncome(
      double totalExpense, double totalIncome) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      return switch (i) {
        0 => PieChartSectionData(
            color: Colors.red,
            value: totalExpense,
            title:
                '${((totalExpense / (totalExpense + totalIncome)) * 100).toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          ),
        1 => PieChartSectionData(
            color: Colors.green,
            value: totalIncome,
            title:
                '${((totalIncome / (totalExpense + totalIncome)) * 100).toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          ),
        _ => throw StateError('Invalid'),
      };
    });
  }

  _setSections(bool isTouched, List<CategorySummary> categories, int i) {
    List<PieChartSectionData> sections = [];
    final fontSize = isTouched ? 25.0 : 16.0;
    final radius = isTouched ? 60.0 : 50.0;
    const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
    for (int j = 0; j < categories.length; j++) {
      sections.add(PieChartSectionData(
        color: categories[j].color != null
            ? Color(int.parse(categories[j].color!.replaceAll('#', '0xFF')))
            : Colors.grey,
        value: categories[j].totalAmount ?? 0,
        title:
            '${((categories[j].totalAmount ?? 0) / (categories.fold(0.0, (sum, item) => sum + (item.totalAmount ?? 0))) * 100).toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      ));
    }

    return sections[i];
  } // ...existing code...

  _categoriesChart(History? history) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Divider(),
        const Text('Distribución por categoría',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Divider(),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(
                      show: true,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections:
                        _showingSections(history?.transactionsByCategory ?? []),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...history!.transactionsByCategory!.map(
                    (d) => Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Indicator(
                        color: d.color != null
                            ? Color(int.parse(d.color!.replaceAll('#', '0xFF')))
                            : Colors.grey,
                        text: d.category ?? 'Sin categoría',
                        isSquare: true,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  _expenseAmountChart(History? history) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Divider(),
        const Text('Distribución de Gastos e ingresos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Divider(),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(
                      show: true,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: _showingSectionsExpenseIncome(
                        history?.totalExpenseByMonth ?? 0,
                        history?.totalIncomeByMonth ?? 0),
                  ),
                ),
              ),
            ),
            const Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Indicator(
                    color: Colors.red,
                    text: 'Gastos',
                    isSquare: true,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Indicator(
                    color: Colors.green,
                    text: 'Ingresos',
                    isSquare: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
// ...existing code...

class HistoryListItem extends StatelessWidget {
  String? title;
  String? subtitle;
  HistoryListItem({super.key, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(subtitle ?? ''),
      ],
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });

  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
