import 'package:get/get.dart';
import 'package:sugar/widgets/account_box.dart';

class SugarFundsPageController extends GetxController {
  RxBool isExpanded = false.obs;
  RxString sugarFundsAmount = "".obs;

  Rx<AccountBox> accountBoxModifying = AccountBox(
    accountName: "sugar daddy balance",
    amount: "0",
    // accountNumber: Colors.red,
    onTap: () {},
  ).obs;

  RxBool hideBodyData = false.obs;

  RxString expenseAmount = "0".obs;
  RxString expenseType = "".obs;

  // Toggle the expanded state
  void toggleExpanded() {
    print("Toggling expanded state");
    isExpanded.value = !isExpanded.value;
  }

  void updateSugarFundsAmount(String amount) {
    sugarFundsAmount.value = amount;
  }

  void setBodyData(bool hideBodyData) {
    this.hideBodyData.value = hideBodyData;
  }

  bool getBodyData() {
    return hideBodyData.value;
  }

  void updateExpenseAmount(String amount) {
    expenseAmount.value = amount;
  }

  void updateExpenseType(String type) {
    expenseType.value = type;
  }

  Map<String, String> getExpense() {
    var amount = expenseAmount.value;
    var type = expenseType.value;

    expenseAmount.value = "";
    expenseType.value = "";

    return {
      "amount": amount,
      "expense_type": type,
    };
  }
}
