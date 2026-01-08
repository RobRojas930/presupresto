class Transaccion {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime date;
  final String type;

  Transaccion({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type,
    };
  }

  // Create from JSON
  factory Transaccion.fromJson(Map<String, dynamic> json) {
    return Transaccion(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      amount: json['amount'] as double,
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
    );
  }
}