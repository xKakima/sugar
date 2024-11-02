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
  RxString lastUpdatedAmount = "0".obs;
  RxInt accountIndex = 0.obs;
  String mainAccountTitle = "";

  RxBool hideBodyData = false.obs;

  Rx<EditingState> editingState = EditingState.editAmount.obs;

  String accountName = "";

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

  void setBodyData(bool hideBodyData) {
    this.hideBodyData.value = hideBodyData;
  }

  void setHeaderColor(String color) {
    headerColor = color;
    accountBoxColor.value = color;
  }

  void setLastUpdatedAmount(String amount) {
    print("Setting last updated amount: $amount");
    lastUpdatedAmount.value = amount;
  }

  void updateAccountName(String name) {
    accountName = name;
    print("New account name: $accountName");
  }

  void updateAccountAmount(String amount) {
    accountAmount.value = amount;
  }

  void resetObservables() {
    accountAmount.value = "0";
    accountId.value = "";
    editableAccountTitle.value = mainAccountTitle;
    lastUpdatedAmount.value = "0";
    accountIndex.value = 0;
    accountName = "";
  }

  bool isNewAccount() {
    return mainAccountTitle != editableAccountTitle.value;
  }

  bool getBodyData() {
    return hideBodyData.value;
  }

  String getLastUpdatedAmount() {
    print("Getting last updated amount: ${lastUpdatedAmount.value}");
    return lastUpdatedAmount.value;
  }

  Map<String, dynamic> getNewAccountData() {
    var amount = formatNumber(accountAmount.value);
    String accId = accountId.value;
    print(accountName == "" || accountName == mainAccountTitle);
    String accName = accountName == "" || accountName == mainAccountTitle
        ? "New Account"
        : accountName;
    print("Account name: $accName");
    int accIndex = accountIndex.value;
    resetObservables();

    print(
        "Returning new account data: $accountId, $accountName, $amount, $accountBoxColor");

    return {
      "id": accId,
      "account_name": accName,
      "balance": amount,
      "color": accountBoxColor.value,
      "account_index": accIndex
    };
  }
}
