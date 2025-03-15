import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sugar/core/database/expense.dart' as expense_db;
import 'package:sugar/core/database/budget.dart';
import 'package:sugar/shared/utils/utils.dart';
import 'package:sugar/shared/widgets/notifier.dart';

class SugarFundsPageController extends GetxController {
  // Expense Types
  final List<String> types = [
    "RAMEN",
    "GROCERY",
    "MEAL",
    "ICE_CREAM",
    "COFFEE",
    "SNACKS",
  ];

  // UI State
  final RxBool isExpanded = false.obs;
  final RxBool hideBodyData = false.obs;

  // Data State
  final RxString expenseAmount = "0".obs;
  final RxString expenseType = "".obs;
  final RxDouble sugarFundsBalance = 0.0.obs;
  final RxBool isExpenseSummed = false.obs;
  final RxInt refreshKey = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBalance();
  }

  // Fetch expenses
  Future<List<Map<String, dynamic>>> fetchExpenses() async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('expense')
        .select()
        .eq('user_id', supabase.auth.currentUser!.id)
        .order('created_at', ascending: false);
    return response;
  }

  // UI State Management
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

  // Expense Management
  void updateExpenseAmount(String amount) {
    expenseAmount.value = amount;
  }

  void updateExpenseType(String type) {
    expenseType.value = type;
    Notifier.show("Selected expense type: $type", 1);
  }

  Future<Map<String, dynamic>> createExpense() async {
    if (expenseAmount.value == "0" || expenseType.value.isEmpty) {
      Notifier.show("Please enter amount and select type", 1);
      return {
        "success": false,
        "message": "Please enter amount and select type"
      };
    }

    try {
      final expenseData = getNewExpenseData();
      final response = await expense_db.addExpense(expenseData);
      if (response['success']) {
        await fetchBalance();
        refreshKey.value++;
        Notifier.show("Expense added successfully", 1);
        resetExpenseInputs();
      }
      return response;
    } catch (e) {
      Notifier.show("Failed to add expense", 1);
      return {"success": false, "message": e.toString()};
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    try {
      await expense_db.deleteExpense(expenseId);
      await fetchBalance();
      refreshKey.value++;
      Notifier.show("Expense deleted", 1);
    } catch (e) {
      Notifier.show("Failed to delete expense", 1);
    }
  }

  // Balance Management
  Future<void> fetchBalance() async {
    try {
      final balance = await fetchMonthlyBalance(DateTime.now().toString());
      sugarFundsBalance.value = double.parse(balance.toString());
    } catch (e) {
      // Log error but continue gracefully with a default value
      sugarFundsBalance.value = 0.0;
    }
  }

  // Helper Methods
  bool getBodyData() {
    return hideBodyData.value;
  }

  void resetExpenseInputs() {
    expenseAmount.value = "0";
    expenseType.value = "";
  }

  Map<String, dynamic> getNewExpenseData() {
    final supabase = Supabase.instance.client;
    return {
      "amount": formatNumber(expenseAmount.value),
      "expense_type": expenseType.value,
      "user_id": supabase.auth.currentUser!.id,
    };
  }
}
