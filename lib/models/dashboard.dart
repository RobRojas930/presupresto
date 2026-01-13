import 'package:presupresto/models/dashboard_category.dart';

class Dashboard {
  final int totalTransactions;
  final double totalAmount;
  final double totalIncome;
  final double totalExpense;
  final double totalSaved;
  final List<DashboardCategory> categories;

  Dashboard({
    required this.totalTransactions,
    required this.totalAmount,
    required this.totalIncome,
    required this.totalExpense,
    required this.totalSaved,
    required this.categories,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      totalTransactions: json['totalTransactions'] ?? 0,
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      totalIncome: (json['totalIncome'] ?? 0).toDouble(),
      totalExpense: (json['totalExpense'] ?? 0).toDouble(),
      totalSaved: (json['totalSaved'] ?? 0).toDouble(),
      categories: (json['categories'] as List<dynamic>?)
              ?.map(
                  (e) => DashboardCategory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalTransactions': totalTransactions,
      'totalAmount': totalAmount,
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'totalSaved': totalSaved,
      'categories': categories.map((e) => e.toJson()).toList(),
    };
  }
}
