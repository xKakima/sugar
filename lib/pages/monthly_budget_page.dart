import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar/database/budget.dart';
import 'package:sugar/widgets/background.dart';
import 'package:sugar/widgets/monthly_budget_ui.dart';
import 'package:sugar/widgets/reset_day_ui.dart';
import 'package:sugar/controller/data_store_controller.dart';
import 'package:sugar/pages/home_page.dart';
import 'package:sugar/widgets/utils.dart';

class MonthlyBudget extends StatefulWidget {
  const MonthlyBudget({super.key});

  @override
  _MonthlyBudgetState createState() => _MonthlyBudgetState();
}

class _MonthlyBudgetState extends State<MonthlyBudget> {
  final dataStore = Get.find<DataStoreController>();
  String value = '0';

  @override
  void initState() {
    super.initState();
    dataStore.setData("monthlyBudgetSelected", false);
  }

  void _updateValue(String newValue) {
    setState(() {
      value = newValue;
    });
  }

  Future<void> _goToHomePage() async {
    print("resetDay ${dataStore.getData("resetDay")}");
    final budgetResponse = await upsertBudget({
      'budget': formatInteger(value),
      'reset_day': dataStore.getData("resetDay"),
    });
    print(budgetResponse);
    dataStore.setData("sweetFundsBalance", value);

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
