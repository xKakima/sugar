import 'package:get/get.dart';
import 'package:sugar/features/sugar_funds/models/sugar_funds_model.dart';
import 'package:sugar/shared/widgets/notifier.dart';

class SugarFundsController extends GetxController {
  final SugarFundsModel model = SugarFundsModel();

  // UI State
  final RxBool isExpanded = false.obs;
  final RxBool hideBodyData = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeData();
  }

  Future<void> initializeData() async {
    await model.fetchExpenses();
    await model.fetchBalance();
  }

  void addExpenseState() {
    setBodyData(true);
    toggleExpanded();
  }

  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }

  void setBodyData(bool value) {
    hideBodyData.value = value;
  }

  bool getBodyData() {
    return hideBodyData.value;
  }

  void updateAmount(String amount) {
    model.updateExpenseAmount(amount);
  }

  void updateExpenseType(String type) {
    model.updateExpenseType(type);
    Notifier.show("Selected expense type: $type", 1);
  }

  Future<void> addExpense() async {
    if (model.expenseAmount.value == "0" || model.expenseType.value.isEmpty) {
      Notifier.show("Please enter amount and select type", 1);
      return;
    }

    try {
      final expenseData = model.getNewExpenseData();
      await model.createExpense(expenseData);
      model.resetExpenseInputs();
      await model.fetchBalance();
      Notifier.show("Expense added successfully", 1);
      toggleExpanded();
    } catch (e) {
      Notifier.show("Failed to add expense", 1);
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    final success = await model.deleteExpense(expenseId);
    if (success) {
      Notifier.show("Expense deleted", 1);
      await model.fetchBalance();
    } else {
      Notifier.show("Failed to delete expense", 1);
    }
  }
}
