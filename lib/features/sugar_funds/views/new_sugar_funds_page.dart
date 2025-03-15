import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar/features/sugar_funds/controllers/sugar_funds_page_controller.dart';
import 'package:sugar/features/sugar_funds/views/new_sugar_funds_header.dart';
import 'package:sugar/features/sugar_funds/views/sugar_funds_content.dart.dart';
import 'package:sugar/shared/widgets/base_page_layout.dart';

// TODO DOUBLE CHECK EVERYTHING SINCE AI MADE IT
class NewSugarFundsPage extends StatelessWidget {
  NewSugarFundsPage({super.key});

  final controller = Get.put(SugarFundsPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BasePageLayout(
        showFooter: true,
        header: Obx(
          () => SugarFundsHeader(
            welcomeText: "test",
          ),
        ),
        onFooterButtonPressed: () => controller.addExpenseState(),
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
