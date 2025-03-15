import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar/shared/models/expense_model.dart';
import 'package:sugar/shared/services/expense_service.dart';
import 'package:sugar/shared/widgets/expense_form.dart';

abstract class BaseFundsController extends GetxController {
  final ExpenseService _expenseService = ExpenseService();
  final RxDouble balance = 0.0.obs;
  final RxBool isLoading = false.obs;
  final RxList<ExpenseModel> expenses = <ExpenseModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBalance();
    fetchExpenses();
  }

  Future<void> fetchBalance() async {
    try {
      isLoading.value = true;
      final expensesList = await _expenseService.getExpenses();
      balance.value = calculateBalance(expensesList);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch balance');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchExpenses() async {
    try {
      isLoading.value = true;
      final expensesList = await _expenseService.getExpenses();
      expenses.assignAll(expensesList);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch expenses');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createExpense() async {
    Get.dialog(
      Dialog(
        child: ExpenseForm(
          onSubmit: (expense) async {
            try {
              isLoading.value = true;
              await _expenseService.addExpense(expense);
              await fetchBalance();
              await fetchExpenses();
              Get.back(); // Close form
              Get.back(); // Return to previous screen
            } catch (e) {
              Get.snackbar('Error', 'Failed to create expense');
            } finally {
              isLoading.value = false;
            }
          },
        ),
      ),
    );
  }

  // Override this in child classes to implement specific balance calculation logic
  double calculateBalance(List<ExpenseModel> expenses);
}
