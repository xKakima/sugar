import 'package:get/get.dart';
import 'package:sugar/budgeted_funds/models/expense_model.dart';
import 'package:sugar/core/database/expense.dart' as expense_db;

class BudgetedFundsController extends GetxController {
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxDouble balance = 0.0.obs;
  final RxList<ExpenseModel> expenses = <ExpenseModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      // TODO: Implement actual data fetching
      await Future.delayed(const Duration(seconds: 1));
      balance.value = 1000.0;
      // Fetch expenses from database
      // final response = await expense_db.getExpenses();
      // if (response['success'] == true) {
      //   expenses.value = (response['data'] as List)
      //       .map((e) => ExpenseModel.fromMap(e))
      //       .toList();
      // }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createExpense(ExpenseModel expense) async {
    isLoading.value = true;
    try {
      final response = await expense_db.addExpense(expense.toMap());
      if (!response['success']) {
        throw Exception(response['message']);
      }
      await fetchData(); // Refresh data after adding expense
    } finally {
      isLoading.value = false;
    }
  }

  void onAddPressed() {
    // TODO: Implement add expense UI flow
    print('Add button pressed');
  }
}
