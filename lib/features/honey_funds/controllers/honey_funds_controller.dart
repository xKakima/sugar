import 'package:sugar/shared/controllers/base_funds_controller.dart';
import 'package:sugar/shared/models/expense_model.dart';

class HoneyFundsController extends BaseFundsController {
  @override
  double calculateBalance(List<ExpenseModel> expenses) {
    // For honey funds, we apply a 10% bonus on all expenses
    // This simulates a rewards or cashback system specific to honey funds
    final baseTotal = expenses.fold(0.0, (total, expense) => total + expense.amount);
    final bonus = baseTotal * 0.1; // 10% bonus
    return baseTotal + bonus;
  }
}
