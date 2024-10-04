import 'package:flutter/material.dart';
import 'package:sugar/components/account_box_visual_blur.dart';
import 'package:sugar/components/background.dart';
import 'package:sugar/components/account_box_dots.dart';
import 'package:sugar/components/plus_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Add dynamic loading from database here
  List<Widget> accountBoxList = [
    AccountBox(
      title: 'sugar baby balance',
      amount: '800,000',
      onTap: () => {print("OPEN ACCOUNT")},
    ),
    AccountBoxBlur(
      title: 'sugar daddy balance',
      amount: '600,000',
      onTap: () => {print("OPEN ACCOUNT")},
    ),
  ];

  void _handlePlusButtonPressed() {
    // Add a new AccountBox to the list
    setState(() {
      accountBoxList.add(
        AccountBoxBlur(
          title: 'new account balance',
          amount: '0',
          onTap: () => {print("OPEN ACCOUNT")},
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40), // Adds some space for top padding
              Text(
                'Mon, 22 September 2024',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Hi, Baby!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.account_circle, color: Colors.white),
                  onPressed: () {
                    // Handle profile navigation
                  },
                ),
              ),
              const SizedBox(height: 16),
              AccountBox(
                title: 'sweet funds REMAINING',
                amount: '10,000',
                onTap: () => {print("OPEN ACCOUNT")},
              ),
              const Divider(color: Colors.white54),
              // Make the account boxes scrollable
              Expanded(
                child: ListView(
                  children: [
                    ...accountBoxList,
                    // You can add more AccountBoxes here or generate them dynamically
                    PlusButton(onPressed: _handlePlusButtonPressed),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
