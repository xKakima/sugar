import 'dart:ui';

import 'package:get/get.dart';
import 'package:sugar/constants/app_colors.dart';
import 'package:sugar/pages/account_page.dart';
import 'package:sugar/utils/utils.dart';
import 'package:sugar/widgets/account_box.dart';

enum EditingState { editAmount, editAccount }

class AccountPageController extends GetxController {
  RxBool isExpanded = false.obs;
  RxString accountAmount = "0".obs;
  String headerColor = AppColors.accountBoxDefault.name;
  RxString accountBoxColor = AppColors.accountBoxDefault.name.obs;
  RxString accountId = "".obs;
  RxString editableAccountTitle = "".obs;
  String mainAccountTitle = "";

  RxBool hideBodyData = false.obs;

  Rx<EditingState> editingState = EditingState.editAmount.obs;

  String accountName = "BANK 01";

  // Toggle the expanded state
  void toggleExpanded() {
    print("Toggling expanded state");
    isExpanded.value = !isExpanded.value;
    if (!isExpanded.value) {
      accountBoxColor.value = headerColor;
    }
  }

  void setAccountTitle(String title) {
    editableAccountTitle.value = title;
    mainAccountTitle = title;
  }

  void setBackToMainTitle() {
    editableAccountTitle.value = mainAccountTitle;
    resetObservables();
  }

  bool isNewAccount() {
    return mainAccountTitle != editableAccountTitle.value;
  }

  void setBodyData(bool hideBodyData) {
    this.hideBodyData.value = hideBodyData;
  }

  bool getBodyData() {
    return hideBodyData.value;
  }

  void updateAccountAmount(String amount) {
    accountAmount.value = amount;
  }

  void setHeaderColor(String color) {
    headerColor = color;
    accountBoxColor.value = color;
  }

  void resetObservables() {
    accountAmount.value = "0";
    accountId.value = "";
    editableAccountTitle.value = "";
  }

  Map<String, dynamic> getNewAccountData() {
    var amount = formatNumber(accountAmount.value);
    String accId = accountId.value;
    resetObservables();

    print(
        "Returning new account data: $accountId, $accountName, $amount, $accountBoxColor");

    return {
      "id": accId,
      "account_name": accountName,
      "balance": amount,
      "color": accountBoxColor.value,
    };
  }
}
