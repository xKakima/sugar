import 'package:get/get.dart';

class SugarFundsPageController extends GetxController {
  RxBool isExpanded = false.obs;
  RxBool isExpenseSummed = false.obs;
  RxString sugarFundsAmount = "".obs;

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
    print("New expense amount: $amount");
  }

  void updateExpenseType(String type) {
    expenseType.value = type;
    print("New expense type: $type");
  }

  Map<String, dynamic> getNewExpenseData() {
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
