class Budget {
  final String id;
  final String title;
  final double initialAmount;
  final double currentAmount;
  final double percentage;
  final String categoryId;
  final String color;
  Budget({
    required this.id,
    required this.title,
    required this.initialAmount,
    required this.currentAmount,
    required this.categoryId,
    required this.percentage,
    required this.color,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['_id'] ?? json['id'] as String,
      title: json['title'] as String,
      initialAmount: (json['initialAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num).toDouble(),
      categoryId: json['categoryId'] as String,
      percentage: json['percentage'] is int
          ? (json['percentage'] as int).toDouble()
          : json['percentage'] as double,
      color: json['color'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'initialAmount': initialAmount,
      'currentAmount': currentAmount,
      'categoryId': categoryId,
      'percentage': percentage,
      'color': color,
    };
  }
}
