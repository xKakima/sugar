import 'package:get/get.dart';
import 'package:sugar/shared/constants/app_colors.dart';
import 'package:sugar/core/database/account.dart';
import 'package:sugar/shared/utils/utils.dart';

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
    // Toggle expanded state and update color
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
    // Update the last modified amount
    lastUpdatedAmount.value = amount;
  }

  void updateAccountName(String name) {
    accountName = name;
    // Account name updated
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
    // Return the last updated amount
    return lastUpdatedAmount.value;
  }

  Map<String, dynamic> getNewAccountData() {
    var amount = formatNumber(accountAmount.value);
    String accId = accountId.value;
    String accName = accountName == "" || accountName == mainAccountTitle
        ? "New Account"
        : accountName;
    int accIndex = accountIndex.value;
    resetObservables();

    // Return account data for update

    return {
      "id": accId,
      "account_name": accName,
      "balance": amount,
      "color": accountBoxColor.value,
      "account_index": accIndex
    };
  }

  Future<void> updateAccount() async {
    try {
      final accountData = getNewAccountData();
      await upsertAccount(accountData);
      toggleExpanded();
    } catch (e) {
      // Handle error gracefully
      Get.snackbar('Error', 'Failed to update account: $e');
    }
  }
}
