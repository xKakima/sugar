import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar/features/sugar_funds/controllers/sugar_funds_page_controller.dart';
import 'package:sugar/features/sugar_funds/views/sugar_funds_content.dart';
import 'package:sugar/shared/constants/app_colors.dart';
import 'package:sugar/shared/utils/utils.dart';
import 'package:sugar/shared/widgets/base_page_layout.dart';
import 'package:sugar/shared/widgets/header.dart';
import 'package:sugar/shared/widgets/profile_icon.dart';
import 'package:sugar/shared/widgets/custom_back_button.dart';

class SugarFundsPage extends StatelessWidget {
  final String title;
  final Color headerColor;
  final bool fromQuickAddExpense;

  const SugarFundsPage({
    super.key,
    required this.title,
    required this.headerColor,
    this.fromQuickAddExpense = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SugarFundsPageController());
    if (fromQuickAddExpense) {
      controller.addExpenseState();
    }
    controller.fetchBalance();

    return Scaffold(
      backgroundColor: Colors.black,
      body: BasePageLayout(
        backgroundColor: AppColors.sugarFundsEmptyBalance.color,
        showFooter: true,
        footerStyle: FooterStyle.plus,
        header: Header(
          title: title,
          leading: Row(
            children: [
              const CustomBackButton(),
              const SizedBox(width: 8),
              Text(
                formattedDate(),
                style: TextStyle(
                  color: Colors.white.withAlpha(153),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          trailing: const ProfileIcon(),
        ),
        onFooterButtonPressed: () => controller.addExpenseState(),
        child: SugarFundsContent(
          title: title,
          headerColor: headerColor,
          fromQuickAddExpense: fromQuickAddExpense,
        ),
      ),
    );
  }
}
