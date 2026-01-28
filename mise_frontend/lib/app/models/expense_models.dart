class Expense {
  final int? id;
  final double amount;
  final String category;
  final String date;
  final bool isShared;

  Expense({
    this.id, 
    required this.amount, 
    required this.category, 
    required this.date, 
    required this.isShared
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      category: json['category'],
      date: json['date'],
      isShared: json['is_shared'] is int 
          ? json['is_shared'] == 1 
          : json['is_shared'] ?? false,
    );
  }
}