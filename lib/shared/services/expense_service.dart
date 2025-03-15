import 'package:sugar/shared/models/expense_model.dart';

class ExpenseService {
  // Simulate a database with an in-memory list
  final List<ExpenseModel> _expenses = [];

  Future<List<ExpenseModel>> getExpenses() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _expenses;
  }

  Future<void> addExpense(ExpenseModel expense) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    _expenses.add(expense);
  }

  Future<void> deleteExpense(String id) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    _expenses.removeWhere((expense) => expense.id == id);
  }
}
