import 'package:flutter_test/flutter_test.dart';
import 'package:sugar/shared/controllers/base_funds_controller.dart';
import 'package:sugar/shared/models/expense_model.dart';

class TestFundsController extends BaseFundsController {
  @override
  double calculateBalance(List<ExpenseModel> expenses) {
    return expenses.fold(0, (total, expense) => total + expense.amount);
  }
}

void main() {
  late TestFundsController controller;

  setUp(() {
    controller = TestFundsController();
  });

  group('BaseFundsController', () {
    test('initial values should be correct', () {
      expect(controller.isLoading.value, false);
      expect(controller.balance.value, 0.0);
      expect(controller.expenses.value, []);
    });

    test('calculateBalance should sum expenses correctly', () {
      final expenses = [
        ExpenseModel(
          id: '1',
          amount: 100.0,
          description: 'Test 1',
          date: DateTime.now(),
        ),
        ExpenseModel(
          id: '2',
          amount: 200.0,
          description: 'Test 2',
          date: DateTime.now(),
        ),
      ];

      final balance = controller.calculateBalance(expenses);
      expect(balance, 300.0);
    });
  });
}
