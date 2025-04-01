import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar/shared/constants/app_colors.dart';
import 'package:sugar/features/home/controllers/home_page_controller.dart';
import 'package:sugar/features/sugar_funds/views/sugar_funds_page.dart';
import 'package:sugar/shared/widgets/base_page_layout.dart';
import 'package:sugar/features/home/views/home_content.dart';
import 'package:sugar/features/home/views/home_header.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final controller = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accountBoxDefault.color,
      body: BasePageLayout(
        showFooter: true,
        footerStyle: FooterStyle.plus,
        header: HomeHeader(
          welcomeText: controller.welcomeText,
        ),
        onFooterButtonPressed: () => Get.to(
          () => SugarFundsPage(
            title: 'sugar funds',
            headerColor: AppColors.sugarFundsBalance.color,
            fromQuickAddExpense: true,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () => HomeContent(
              sugarFundsBalance: controller.sugarFundsBalance.value,
              balanceBoxWidgets: controller.balanceBoxWidgets,
              isLoading: controller.isLoading.value,
            ),
          ),
        ),
      ),
    );
  }
}
