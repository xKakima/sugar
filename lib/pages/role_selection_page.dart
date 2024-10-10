import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sugar/widgets/background.dart';
import 'package:sugar/widgets/buttons/rectangle_button.dart';
import 'package:sugar/controller/data_store_controller.dart';
import 'package:sugar/database/user_data.dart';
import 'package:sugar/pages/invite_page.dart';
import 'package:sugar/widgets/notifier.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  _RoleSelectionPageState createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  String selectedRole = '';

  final dataStore = Get.find<DataStoreController>();

  Future<void> _onRoleSelected(String role) async {
    setState(() {
      selectedRole = role;
    });
    final upsertResponse = await upsertUserData({"userType": selectedRole});

    dataStore.setData("userType", role);

    print("upsert response ${upsertResponse}");

    Get.to(InvitePage(role: role));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              const SizedBox(
                  height:
                      100), // Adjust this to control the spacing from the top

              // Use a Row to place the text and icon beside each other
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon in the middle
                  Image.asset(
                    'assets/images/selection_icon.png',
                    width: 150, // Adjust the size as per your design
                    height: 150,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'who\nare\nyou?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.right, // Align the text properly
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 100),
              // Buttons for sugar daddy and sugar baby
              RectangleButton(
                onPressed: () {
                  _onRoleSelected('DADDY');
                },
                text: 'sugar daddy',
              ),
              const SizedBox(height: 20),
              RectangleButton(
                onPressed: () {
                  _onRoleSelected('BABY');
                },
                text: 'sugar baby',
              ),
              const Spacer(), // Keeps buttons towards the bottom
            ],
          ),
        ),
      ),
    );
  }
}
