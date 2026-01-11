class DashboardCategory {
  final String category;
  final int total;
  final double totalExpensesAmount;
  final double percentage;
  final String color;
  final String icon;

  DashboardCategory({
    required this.category,
    required this.total,
    required this.totalExpensesAmount,
    required this.percentage,
    required this.color,
    required this.icon,
  });

  factory DashboardCategory.fromJson(Map<String, dynamic> json) {
    return DashboardCategory(
      category: json['category'] as String,
      color: json['color'] as String,
      icon: json['icon'] as String,
      total: json['total'] ?? 0,
      totalExpensesAmount: double.parse(json['totalExpensesAmount'].toString()),
      percentage: double.parse(json['percentage'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'color': color,
      'icon': icon,
      'total': total,
      'totalExpensesAmount': totalExpensesAmount,
      'percentage': percentage,
    };
  }
}
