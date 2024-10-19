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
}
