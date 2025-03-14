import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar/shared/constants/app_colors.dart';
import 'package:sugar/features/home/controllers/home_page_controller.dart';
import 'package:sugar/features/sugar_funds/views/sugar_funds_page.dart';
import 'package:sugar/shared/widgets/base_page_layout.dart';
import 'package:sugar/features/home/views/home_content.dart';
import 'package:sugar/features/home/views/home_header.dart';

class NewSugarFundsPage extends StatelessWidget {
  NewSugarFundsPage({super.key});

  final controller = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: BasePageLayout(
            showFooter: true,
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
        ),
      );
}