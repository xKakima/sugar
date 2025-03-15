import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar/budgeted_funds/views/budgeted_funds_content.dart';
import 'package:sugar/shared/constants/app_colors.dart';
import 'package:sugar/shared/utils/utils.dart';
import 'package:sugar/shared/widgets/base_page_layout.dart';
import 'package:sugar/shared/widgets/buttons/back_button.dart';
import 'package:sugar/shared/widgets/header.dart';
import 'package:sugar/shared/widgets/profile_icon.dart';

class BudgetedFundsPage extends StatelessWidget {
  final String title;
  final GetxController controller;
  final VoidCallback onAddPressed;

  const BudgetedFundsPage({
    super.key,
    required this.title,
    required this.controller,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BasePageLayout(
        backgroundColor: AppColors.budgetedFundsHeader.color,
        showFooter: true,
        footerStyle: FooterStyle.plus,
        header: Header(
          title: title,
          leading: Row(
            children: [
              CustomBackButton(),
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
          // subtitle: const Text(
          //   'Manage your budgeted expenses',
          //   style: TextStyle(color: Colors.white70),
          // ),
        ),
        onFooterButtonPressed: onAddPressed,
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: BudgetedFundsContent(),
        ),
      ),
    );
  }
}
