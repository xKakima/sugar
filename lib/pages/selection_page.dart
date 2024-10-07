import 'package:flutter/material.dart';
import 'package:sugar/components/background.dart';
import 'package:sugar/components/buttons/rectangle_button.dart';
import 'package:sugar/pages/invite_page.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  String selectedRole = '';

  void _onRoleSelected(String role) {
    setState(() {
      selectedRole = role;
    });

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
            mainAxisAlignment: MainAxisAlignment.center,
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
              const Spacer(),
              const Text(
                'who\nare\nyou',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 40),
              RectangleButton(
                  onPressed: () {
                    _onRoleSelected('sugar_daddy');
                  },
                  text: 'sugar daddy'),
              const SizedBox(height: 20),
              RectangleButton(
                  onPressed: () {
                    _onRoleSelected('sugar_baby');
                  },
                  text: 'sugar baby'),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
