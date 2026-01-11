import 'package:presupresto/models/category.dart';

class  Transaction {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime date;
  final Category category;
  final String type;
  final String userId;

  Transaction({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type,
      'category': category.toJson(),
    };
  }

  // Create from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    final amount = json['amount'] is int
        ? (json['amount'] as int).toDouble()
        : json['amount'] is String
            ? 0.0
            : json['amount'] as double;
    return Transaction(
      id: json['_id'] as String,
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String,
      description: json['description'] as String,
      amount: amount,
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
    );
  }
}
