import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar/features/sugar_funds/views/sugar_funds_page.dart';
import 'package:sugar/shared/constants/app_colors.dart';
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
          onTap: () => Get.to(
            () => SugarFundsPage(
              title: 'sugar funds',
              headerColor: AppColors.sugarFundsBalance.color,
            ),
          ),
          color: AppColors.sugarFundsFullBalance.name,
        ),
        BalanceBox(
          title: 'honey funds',
          amount: sugarFundsBalance,
          onTap: () {},
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
