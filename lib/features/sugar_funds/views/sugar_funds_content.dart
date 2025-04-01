import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar/features/sugar_funds/controllers/sugar_funds_page_controller.dart';
import 'package:sugar/features/sugar_funds/models/expense_data.dart';
import 'package:sugar/shared/utils/utils.dart';
import 'package:sugar/shared/widgets/base_page_layout.dart';
import 'package:sugar/shared/widgets/expense_card.dart';
import 'package:sugar/shared/widgets/numpad.dart';
import 'package:sugar/shared/widgets/plus_button.dart';
import 'package:sugar/shared/widgets/rounded_container.dart';
import 'package:sugar/features/sugar_funds/views/sugar_funds_page_header.dart';
import 'package:sugar/shared/widgets/swipeable_list_item.dart';

class SugarFundsContent extends GetView<SugarFundsPageController> {
  final String title;
  final Color headerColor;
  final bool fromQuickAddExpense;

  SugarFundsContent({
    super.key,
    required this.title,
    required this.headerColor,
    this.fromQuickAddExpense = false,
  }) {
    Get.put(SugarFundsPageController());
    if (fromQuickAddExpense) {
      controller.addExpenseState();
    }
    controller.fetchBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BasePageLayout(
        child: Obx(() => FutureBuilder<List<Map<String, dynamic>>>(
              future: controller.fetchExpenses(),
              key: ValueKey(controller.refreshKey.value),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final expensesData = snapshot.data ?? [];
                final expenses = expensesData
                    .map((data) => ExpenseData.fromMap(data))
                    .toList();

                if (snapshot.hasData) {
                  controller.fetchBalance();
                }

                return _buildMainContent(context, expenses);
              },
            )),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, List<ExpenseData> expenses) {
    return Stack(
      children: [
        _buildHeader(context),
        _buildAnimatedContainer(context, expenses),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        color: headerColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.05,
          left: 16,
          right: 16,
        ),
        child: SugarFundsPageHeader(
          title: title,
          balance: controller.sugarFundsBalance.value.toString(),
          isExpanded: controller.isExpanded.value,
        ),
      ),
    );
  }

  Widget _buildAnimatedContainer(
      BuildContext context, List<ExpenseData> expenses) {
    return Obx(
      () => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: MediaQuery.of(context).size.height *
              (controller.isExpanded.value ? 0.84 : 0.75),
          child: RoundedContainer(
            isLarge: true,
            margin: 0,
            child: _buildBodyContent(context, expenses),
          ),
        ),
      ),
    );
  }

  Widget _buildBodyContent(BuildContext context, List<ExpenseData> expenses) {
    return Obx(
      () => controller.hideBodyData.value
          ? const SizedBox()
          : controller.isExpanded.value
              ? _buildAddExpenseSection(context)
              : _buildExpensesList(context, expenses),
    );
  }

  Widget _buildExpensesList(BuildContext context, List<ExpenseData> expenses) {
    return Stack(
      children: [
        Column(
          children: [
            const Text(
              'EXPENSES',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: expenses.isEmpty
                  ? const Center(child: Text('No expenses available.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        final expense = expenses[index];
                        return SwipeableListItem(
                          child: ExpenseCard(
                            amount: expense.amount,
                            type: expense.type,
                            date: expense.date,
                          ),
                          onSwipe: () => controller.deleteExpense(expense.id),
                        );
                      },
                    ),
            ),
          ],
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: PlusButton(
            onPressed: controller.addExpenseState,
          ),
        ),
      ],
    );
  }

  Widget _buildAddExpenseSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: getHeightPercentage(context, 1.5)),
        const Text(
          'CATEGORY',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: getHeightPercentage(context, 1.5)),
        _buildExpenseTypeGrid(context),
        SizedBox(height: getHeightPercentage(context, 2.5)),
        const Text(
          'EDIT AMOUNT',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: getHeightPercentage(context, 1.5)),
        Obx(() => Text(
              controller.expenseAmount.value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            )),
        Expanded(
          child: Numpad(
            onValueChanged: controller.updateExpenseAmount,
            onSubmit: () async {
              final response = await controller.createExpense();
              if (response['success']) {
                controller.toggleExpanded();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseTypeGrid(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const SizedBox.shrink(),
        ...controller.types.map(_buildTypeButton),
        const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildTypeButton(String type) {
    return Obx(() => GestureDetector(
          onTap: () => controller.updateExpenseType(type),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: controller.expenseType.value == type
                  ? const Color.fromARGB(255, 111, 111, 111)
                  : const Color.fromARGB(255, 52, 52, 52),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(
              getTypeImageString(type),
              width: 35,
              height: 35,
            ),
          ),
        ));
  }
}
