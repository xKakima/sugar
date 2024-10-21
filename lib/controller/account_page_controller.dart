import 'package:get/get.dart';
import 'package:sugar/widgets/account_box.dart';

class AccountPageController extends GetxController {
  RxBool isExpanded = false.obs;
  RxDouble accountAmount = 0.0.obs;
  Rx<AccountBox> accountBoxModifying = AccountBox(
    accountName: "sugar daddy balance",
    amount: "0",
    // accountNumber: Colors.red,
    onTap: () {},
  ).obs;

  // Toggle the expanded state
  void toggleExpanded() {
    print("Toggling expanded state");
    isExpanded.value = !isExpanded.value;
  }

  void updateAccountAmount(double amount) {
    accountAmount.value = amount;
  }

  void updateAccountBox(AccountBox accountBox) {
    accountBoxModifying.value = accountBox;
  }
}
