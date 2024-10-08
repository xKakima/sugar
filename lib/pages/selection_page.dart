import 'package:flutter/material.dart';
import 'package:sugar/components/background.dart';
import 'package:sugar/components/buttons/rectangle_button.dart';
import 'package:sugar/database/user_data.dart';
import 'package:sugar/pages/invite_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  String selectedRole = '';

  Future<void> _onRoleSelected(String role) async {
    setState(() {
      selectedRole = role;
    });
    String userType = role == 'sugar_daddy' ? "DADDY" : "BABY";
    final upsertResponse = await upsertUserData({"user_type": userType});

    print("upsert response ${upsertResponse}");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InvitePage(role: role)),
    );
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
                  _onRoleSelected('sugar_daddy');
                },
                text: 'sugar daddy',
              ),
              const SizedBox(height: 20),
              RectangleButton(
                onPressed: () {
                  _onRoleSelected('sugar_baby');
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
