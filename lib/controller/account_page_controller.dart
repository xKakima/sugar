import 'package:get/get.dart';

class AccountPageController extends GetxController {
  RxBool isExpanded = false.obs;

  // Toggle the expanded state
  void toggleExpanded() {
    print("Toggling expanded state");
    isExpanded.value = !isExpanded.value;
  }
}
