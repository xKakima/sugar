class ExpenseModel {
  final String id;
  final DateTime date;
  final String type;
  final double amount;

  ExpenseModel({
    required this.id,
    required this.date,
    required this.type,
    required this.amount,
  });

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'],
      date: DateTime.parse(map['created_at']),
      type: map['expense_type'],
      amount: double.parse(map['amount']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      // date: auto generated
      'expense_type': type,
      'amount': amount,
    };
  }
}
