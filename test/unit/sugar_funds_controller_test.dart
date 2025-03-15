import 'package:flutter_test/flutter_test.dart';
import 'package:sugar/features/sugar_funds/controllers/sugar_funds_controller.dart';
import 'package:sugar/shared/models/expense_model.dart';

void main() {
  late SugarFundsController controller;

  setUp(() {
    controller = SugarFundsController();
  });

  group('SugarFundsController', () {
    test('calculateBalance should sum expenses without modification', () {
      final expenses = [
        ExpenseModel(
          id: '1',
          amount: 100.0,
          description: 'Sugar Test 1',
          date: DateTime.now(),
        ),
        ExpenseModel(
          id: '2',
          amount: 200.0,
          description: 'Sugar Test 2',
          date: DateTime.now(),
        ),
      ];

      final balance = controller.calculateBalance(expenses);
      expect(balance, 300.0);
    });
  });
}
