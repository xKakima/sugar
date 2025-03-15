import 'package:sugar/shared/controllers/base_funds_controller.dart';
import 'package:sugar/shared/models/expense_model.dart';

class SugarFundsController extends BaseFundsController {
  @override
  double calculateBalance(List<ExpenseModel> expenses) {
    // For sugar funds, we simply sum all expenses
    return expenses.fold(0, (total, expense) => total + expense.amount);
  }
}
