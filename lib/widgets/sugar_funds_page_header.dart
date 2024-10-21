import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar/controller/sugar_funds_page_controller.dart';
import 'package:sugar/widgets/buttons/back_button.dart';
import 'package:sugar/widgets/profile_icon.dart';
import 'package:sugar/utils/utils.dart';

class SugarFundsPageHeader extends StatelessWidget {
  final String title;
  final String balance;
  final bool isExpanded;
  final SugarFundsPageController controller =
      Get.put(SugarFundsPageController());

  SugarFundsPageHeader({
    super.key,
    required this.title,
    required this.balance,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (isExpanded)
                  CustomBackButton(
                    onPressed: () => {
                      controller.toggleExpanded(),
                      controller.expenseAmount.value = "0"
                    },
                  )
                else
                  const CustomBackButton(),
                const SizedBox(width: 4),
                Text(
                  formattedDate(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const ProfileIcon(),
          ],
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        AnimatedOpacity(
          opacity:
              isExpanded ? 0.0 : 1.0, // Use the isExpanded state to hide/show
          duration: const Duration(milliseconds: 300),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'REMAINING BALANCE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'PHP ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    balance.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
