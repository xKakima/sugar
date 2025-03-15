import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar/budgeted_funds/views/budgeted_funds_page.dart';
import 'package:sugar/features/honey_funds/controllers/honey_funds_controller.dart';
import 'package:sugar/features/sugar_funds/controllers/sugar_funds_controller.dart';
import 'package:sugar/features/sugar_funds/views/sugar_funds_content.dart.dart';
import 'package:sugar/shared/constants/app_colors.dart';
import 'package:sugar/features/sugar_funds/views/sugar_funds_page.dart';
import 'package:sugar/shared/widgets/balance_box.dart';

class HomeContent extends StatelessWidget {
  final String sugarFundsBalance;
  final List<Widget> balanceBoxWidgets;
  final bool isLoading;

  const HomeContent({
    super.key,
    required this.sugarFundsBalance,
    required this.balanceBoxWidgets,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text(
            "Budget",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        BalanceBox(
          title: 'sugar funds',
          amount: sugarFundsBalance,
          // onTap: () => Get.to(
          //   () => SugarFundsPage(
          //     title: 'sugar funds',
          //     headerColor: AppColors.sugarFundsBalance.color,
          //   ),
          // ),
          onTap: () {
            final controller = Get.put(SugarFundsController());
            Get.to(() => BudgetedFundsPage(
                  title: 'Sugar Funds',
                  controller: controller,
                  onAddPressed: () => controller.createExpense(),
                ));
          },
          color: AppColors.sugarFundsFullBalance.name,
        ),
        BalanceBox(
          title: 'honey funds',
          amount: sugarFundsBalance,
          onTap: () {
            final controller = Get.put(HoneyFundsController());
            Get.to(() => BudgetedFundsPage(
                  title: 'Honey Funds',
                  controller: controller,
                  onAddPressed: () => controller.createExpense(),
                ));
          },
          color: AppColors.sugarFundsFullBalance.name,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text(
            "Balance",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          )
        else
          Column(
            children: balanceBoxWidgets,
          ),
      ],
    );
  }
}
