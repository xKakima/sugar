import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar/database/user_data.dart';
import 'package:sugar/pages/home_page.dart';
import 'package:sugar/pages/role_selection_page.dart';
import 'package:sugar/widgets/background.dart';
import 'package:sugar/widgets/notifier.dart';
import 'package:sugar/widgets/utils.dart';
import 'package:sugar/controller/data_store_controller.dart';
import 'package:sugar/pages/invite_page.dart';

class PartnerCodePage extends StatefulWidget {
  const PartnerCodePage({super.key});

  @override
  _PartnerCodePageState createState() => _PartnerCodePageState();
}

class _PartnerCodePageState extends State<PartnerCodePage> {
  final TextEditingController _partnerCodeController = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // Create a FocusNode
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

    // Add listener to the FocusNode to detect focus changes
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        print("TextField is focused (clicked).");
      } else {
        print("TextField lost focus (closed).");
      }
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
      final codeResponse = await findPartner(code);
      print("codeResponse: $codeResponse");

      if (codeResponse.isEmpty) {
        // Check if the list is empty correctly
        Notifier.show("Invalid partner code!", 3);
        _hasCheckedPartnerCode = false;
      } else {
        // Notifier.show("Partner Found!", 3);
        print("codeResponse 0: ${codeResponse[0]}");
        print("codeResponse 0 userid: ${codeResponse[0]['user_id']}");

        String userType =
            codeResponse[0]['user_type'] == 'DADDY' ? 'BABY' : 'DADDY';
        final upsertResponse = await upsertUserData(
            {'partner_id': codeResponse[0]['user_id'], 'user_type': userType});
        if (upsertResponse['success']) {
          await upsertUserData({
            'user_id': codeResponse[0]['user_id'],
            'partner_id': supabase.auth.currentUser!.id
          });
          Notifier.show("Partner code added successfully!", 3);
          dataStore.setData("partnerId", codeResponse[0]['user_id']);
          Get.to(() => HomePage());
        } else {
          Notifier.show("Something went wrong. Please try again.", 3);
        }
        _hasCheckedPartnerCode = false;
      }
    } catch (e) {
      print("Error checking partner code: $e");
      Notifier.show("Something went wrong. Please try again.", 3);
      _hasCheckedPartnerCode = false;
    }
  }

  void onConfirm() {
    print("Test"); // Update the flag to true
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
                          focusNode: _focusNode, // Attach the FocusNode
                          textInputAction: TextInputAction
                              .done, // Sets "Done" or "Enter" on the keyboard
                          onSubmitted: (value) {
                            // Call checkPartnerCode when the user presses Enter
                            checkPartnerCode();
                          },
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
