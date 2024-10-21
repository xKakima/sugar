import 'dart:ui';

import 'package:get/get.dart';
import 'package:sugar/constants/app_colors.dart';
import 'package:sugar/widgets/account_box.dart';

class AccountPageController extends GetxController {
  RxBool isExpanded = false.obs;
  RxString accountAmount = "0".obs;
  Rx<AccountBox> accountBoxModifying = AccountBox(
    accountName: "sugar daddy balance",
    amount: "0",
    // accountNumber: Colors.red,
    onTap: () {},
  ).obs;

  Rx<Color> headerColor = AppColors.accountBoxDefault.color.obs;

  RxBool hideBodyData = false.obs;

  // Toggle the expanded state
  void toggleExpanded() {
    print("Toggling expanded state");
    isExpanded.value = !isExpanded.value;
  }

  void updateAccountAmount(String amount) {
    accountAmount.value = amount;
  }

  void updateAccountBox(AccountBox accountBox) {
    accountBoxModifying.value = accountBox;
  }
}
