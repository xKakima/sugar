import 'package:flutter/material.dart';
import 'package:sugar/components/background.dart';
import 'package:sugar/components/balance_box.dart';
import 'package:sugar/components/plus_button.dart';
import 'package:sugar/components/profile_icon.dart';
import 'package:sugar/pages/account_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _goToAccountPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            const AccountPage(), // Replace with your AccountsPage
      ),
    );
  }

  // Add dynamic loading from database here

  @override
  Widget build(BuildContext context) {
    List<Widget> balanceBoxList = [
      BalanceBox(
        title: 'sugar baby balance',
        amount: '800,000',
        onTap: _goToAccountPage,
      ),
      BalanceBox(
        title: 'sugar daddy balance',
        amount: '600,000',
        onTap: () => _goToAccountPage,
        hasNoLink: true,
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Background(
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
                  const SizedBox(height: 16),
                  BalanceBox(
                    title: 'sweet funds REMAINING',
                    amount: '10,000',
                    onTap: () => {print("OPEN ACCOUNT")},
                  ),
                  const Divider(color: Colors.white54),
                  // Make the account boxes scrollable
                  Expanded(
                    child: ListView(
                      children: [
                        ...balanceBoxList,
                        // You can add more AccountBoxes here or generate them dynamically
                      ],
                    ),
                  ),
                  PlusButton(
                    onPressed: () => {print("ADD ACCOUNT")},
                  ),
                ],
              ),
            ),
          ),
          // Use the reusable ProfileIcon
          ProfileIcon(),
        ],
      ),
    );
  }
}
