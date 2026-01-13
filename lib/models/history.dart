class History {
  final List<Transaction>? transactions;
  final int? countTransactions;
  final double? totalTransactionsAmount;

  final double? totalExpenseByMonth;
  final double? totalIncomeByMonth;

  final int? countTransactionsByMonth;
  final double? totalTransactionsByMonth;

  final List<CategorySummary>? transactionsByCategory;

  History({
    this.transactions,
    this.countTransactions,
    this.totalTransactionsAmount,
    this.totalExpenseByMonth,
    this.totalIncomeByMonth,
    this.countTransactionsByMonth,
    this.totalTransactionsByMonth,
    this.transactionsByCategory,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      transactions: json['transactions'] != null
          ? (json['transactions'] as List)
              .map((e) => Transaction.fromJson(e))
              .toList()
          : null,
      countTransactions: json['countTransactions'],
      totalTransactionsAmount: json['totalTransactionsAmount']?.toDouble(),
      totalExpenseByMonth: json['totalExpenseByMonth']?.toDouble(),
      totalIncomeByMonth: json['totalIncomeByMonth']?.toDouble(),
      countTransactionsByMonth: json['countTransactionsByMonth'] as int?,
      totalTransactionsByMonth: json['totalTransactionsByMonth']?.toDouble(),
      transactionsByCategory: json['transactionsByCategory'] != null
          ? (json['transactionsByCategory'] as List)
              .map((e) => CategorySummary.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactions': transactions?.map((e) => e.toJson()).toList(),
      'countTransactions': countTransactions,
      'totalTransactionsAmount': totalTransactionsAmount,
      'totalExpenseByMonth': totalExpenseByMonth,
      'totalIncomeByMonth': totalIncomeByMonth,
      'countTransactionsByMonth': countTransactionsByMonth,
      'totalTransactionsByMonth': totalTransactionsByMonth,
      'transactionsByCategory':
          transactionsByCategory?.map((e) => e.toJson()).toList(),
    };
  }
}

class CategorySummary {
  final String? category;
  final int? count;
  final double? totalAmount;
  final String? color;

  CategorySummary({this.category, this.count, this.totalAmount, this.color});

  factory CategorySummary.fromJson(Map<String, dynamic> json) {
    return CategorySummary(
      category: json['category'],
      count: json['count'],
      totalAmount: json['totalAmount']?.toDouble(),
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'count': count,
      'totalAmount': totalAmount,
      'color': color,
    };
  }
}

// Nota: Necesitarás definir la clase Transaction por separado
class Transaction {
  // Define los campos según tu modelo de Transaction

  Transaction();

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
