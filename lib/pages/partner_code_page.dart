import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar/database/budget.dart';
import 'package:sugar/database/user_data.dart';
import 'package:sugar/pages/home_page.dart';
import 'package:sugar/pages/role_selection_page.dart';
import 'package:sugar/widgets/background.dart';
import 'package:sugar/widgets/notifier.dart';
import 'package:sugar/utils/utils.dart';
import 'package:sugar/controller/data_store_controller.dart';

class PartnerCodePage extends StatefulWidget {
  const PartnerCodePage({super.key});

  @override
  _PartnerCodePageState createState() => _PartnerCodePageState();
}

class _PartnerCodePageState extends State<PartnerCodePage> {
  final TextEditingController _partnerCodeController = TextEditingController();
  String _previousText = ''; // Store the previous text to detect paste events
  final dataStore = Get.find<DataStoreController>();
  bool _hasCheckedPartnerCode = false;

  void initState() {
    super.initState();

    // Listen to text changes in the input field
    _partnerCodeController.addListener(() {
      final currentText = _partnerCodeController.text;

      // Detect if text has been pasted (sudden increase in length)
      if (currentText.length > _previousText.length + 3) {
        print("Text was pasted: $currentText");
        // showNotifier("Text was pasted!");
      }

      // Update the previous text
      _previousText = currentText;
    });
  }

  Future<void> checkPartnerCode() async {
    if (_hasCheckedPartnerCode) return;
    _hasCheckedPartnerCode = true;

    final code = _partnerCodeController.text;
    _partnerCodeController.clear(); // Clear the input field
    if (code.isEmpty) {
      Notifier.show("Please enter a code!", 3);
      return;
    }

    try {
      final partnerId = await addPartner(code);
      print("Code response: $partnerId");
      if (partnerId == '') {
        Notifier.show("Invalid code. Please try again.", 3);
        _hasCheckedPartnerCode = false;
        return;
      }

      Notifier.show("Partner code added successfully!", 3);
      dataStore.setData("partnerCode", code);

      final balance = await fetchMonthlyBalance(partnerId);
      dataStore.setData("sugarFundsBalance", balance);
      final userData = await fetchUserData();
      dataStore.setData("userType", userData['user_type'].toString());
      print("Budget: $balance");

      Get.to(() => HomePage());

      _hasCheckedPartnerCode = false;
    } catch (e) {
      print("Error checking partner code: $e");
      Notifier.show("Something went wrong. Please try again.", 3);
      _hasCheckedPartnerCode = false;
    }
  }

  @override
  void dispose() {
    _partnerCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Allows content to adjust when the keyboard opens
      body: Background(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 100),

              // Use Flexible or Expanded to avoid layout issues
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: getWidthPercentage(context, 30)),
                          const Text(
                            'enter your\npartner code',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),

                      // Partner code input field
                      SizedBox(
                        width: getWidthPercentage(context, 60),
                        child: TextField(
                          controller: _partnerCodeController,
                          decoration: InputDecoration(
                            hintText: 'Enter code here',
                            filled: true,
                            fillColor: const Color.fromARGB(255, 92, 131, 116),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Clickable text
                      GestureDetector(
                        onTap: () {
                          Get.to(() => RoleSelectionPage());
                        },
                        child: const Text(
                          "i don't have one... yet.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: getHeightPercentage(context, 30)),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: IconButton(
                          icon: const Icon(Icons.check_box,
                              color: Colors.white, size: 50),
                          onPressed: checkPartnerCode,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
