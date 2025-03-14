import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar/core/services/data_store_controller.dart';
import 'package:sugar/core/database/budget.dart';
import 'package:sugar/features/home/views/home_page.dart';
import 'package:sugar/shared/widgets/background.dart';
import 'package:sugar/shared/widgets/monthly_budget_ui.dart';
import 'package:sugar/shared/widgets/reset_day_ui.dart';

class MonthlyBudgetPage extends StatefulWidget {
  const MonthlyBudgetPage({super.key});

  @override
  State<MonthlyBudgetPage> createState() => MonthlyBudgetState();
}

class MonthlyBudgetState extends State<MonthlyBudgetPage> {
  final dataStore = Get.find<DataStoreController>();
  String value = '0';

  @override
  void initState() {
    super.initState();
    dataStore.setData("monthlyBudgetSelected", false);
  }

  void _updateValue(String newValue) {
    value = newValue;
  }

  Future<void> _goToHomePage() async {
    await upsertBudget({
      'budget': value,
      'balance': value,
      'reset_day': dataStore.getData("resetDay"),
    }, ownerIsUser: true);
    dataStore.sugarFundsBalance.value = value;

    Get.to(() => HomePage());
  }

  void confirmBudget() {
    dataStore.setData("monthlyBudgetSelected", true); // Update the flag to true
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            if (dataStore.getData("monthlyBudgetSelected")) {
              // Show Reset Day UI if the budget is already set
              return ResetDayUI(
                onConfirm: _goToHomePage, // Add logic for confirming reset day
              );
            } else {
              // Show Monthly Budget UI
              return MonthlyBudgetUI(
                value: value,
                onValueChanged: _updateValue,
                onConfirm: confirmBudget, // Call confirmBudget() when confirmed
              );
            }
          }),
        ),
      ),
    );
  }
}
