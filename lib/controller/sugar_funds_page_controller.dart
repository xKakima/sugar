import 'package:get/get.dart';
import 'package:sugar/utils/utils.dart';
import 'package:sugar/widgets/account_box.dart';

class SugarFundsPageController extends GetxController {
  RxBool isExpanded = false.obs;
  RxDouble sugarFundsAmount = 0.0.obs;

  Rx<AccountBox> accountBoxModifying = AccountBox(
    accountName: "sugar daddy balance",
    amount: "0",
    // accountNumber: Colors.red,
    onTap: () {},
  ).obs;

  RxBool hideBodyData = false.obs;

  RxDouble expenseAmount = 0.0.obs;
  RxString expenseType = "".obs;

  // Toggle the expanded state
  void toggleExpanded() {
    print("Toggling expanded state");
    isExpanded.value = !isExpanded.value;
  }

  void updateSugarFundsAmount(double amount) {
    sugarFundsAmount.value = amount;
  }

  void setBodyData(bool hideBodyData) {
    this.hideBodyData.value = hideBodyData;
  }

  bool getBodyData() {
    return hideBodyData.value;
  }

  void updateExpenseAmount(double amount) {
    expenseAmount.value = amount;
    print("New expense amount: $amount");
  }

  void updateExpenseType(String type) {
    expenseType.value = type;
    print("New expense type: $type");
  }

  Map<String, dynamic> getNewExpenseData() {
    var amount = expenseAmount.value;
    var type = expenseType.value;

    expenseAmount.value = 0.0;
    expenseType.value = "";

    return {
      "amount": amount,
      "expense_type": type,
    };
  }
}
