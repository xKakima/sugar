import 'package:get/get.dart';
import 'package:sugar/core/database/budget.dart';
import 'package:sugar/core/database/expense.dart' as expense_db;
import 'package:sugar/features/sugar_funds/models/expense_data.dart';

class SugarFundsModel {
  final RxList<ExpenseData> expenses = <ExpenseData>[].obs;
  final RxDouble balance = 0.0.obs;
  final RxString expenseAmount = "0".obs;
  final RxString expenseType = "".obs;

  final List<String> expenseTypes = [
    "RAMEN",
    "GROCERY",
    "MEAL",
    "ICE_CREAM",
    "COFFEE",
    "SNACKS",
  ];

  Future<void> fetchExpenses() async {
    try {
      final response = await expense_db.getExpenses();
      if (response != null) {
        expenses.value = response
            .map((expense) => ExpenseData(
                  id: expense['id'],
                  date: DateTime.parse(expense['created_at']),
                  type: expense['expense_type'],
                  amount: expense['amount'].toString(),
                ))
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));
      }
    } catch (e) {
      // Log error but continue gracefully
      expenses.value = [];
    }
  }

  Future<void> fetchBalance() async {
    final monthlyBalance = await fetchMonthlyBalance(DateTime.now().toString());
    balance.value = double.parse(monthlyBalance.toString());
  }

  Future<bool> deleteExpense(String expenseId) async {
    try {
      await expense_db.deleteExpense(expenseId);
      return true;
    } catch (e) {
      // Log error but continue gracefully
      return false;
    }
  }

  void updateExpenseAmount(String amount) {
    expenseAmount.value = amount;
  }

  void updateExpenseType(String type) {
    expenseType.value = type;
  }

  Future<bool> createExpense(Map<String, dynamic> expenseData) async {
    try {
      await expense_db.addExpense(expenseData);
      return true;
    } catch (e) {
      // Log error but continue gracefully
      return false;
    }
  }

  Map<String, dynamic> getNewExpenseData() {
    return {
      "amount": double.parse(expenseAmount.value),
      "expense_type": expenseType.value,
    };
  }

  void resetExpenseInputs() {
    expenseAmount.value = "0";
    expenseType.value = "";
  }
}
