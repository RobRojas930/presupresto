class Budget {
  final int id;
  final String title;
  final double initialAmount;
  final double currentAmount;
  final int idCategory;

  Budget({
    required this.id,
    required this.title,
    required this.initialAmount,
    required this.currentAmount,
    required this.idCategory,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'] as int,
      title: json['title'] as String,
      initialAmount: (json['initialAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num).toDouble(),
      idCategory: json['idCategory'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'initialAmount': initialAmount,
      'currentAmount': currentAmount,
      'idCategory': idCategory,
    };
  }
}