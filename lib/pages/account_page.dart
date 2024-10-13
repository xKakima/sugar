import 'package:flutter/material.dart';
import 'package:sugar/widgets/background.dart';
import 'package:sugar/widgets/profile_icon.dart';
import 'package:sugar/widgets/account_box.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Text(
                        'Mon, 22 September 2024',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'sugar baby balance',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'TOTAL AMOUNT',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'PHP 800,000',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'ACCOUNTS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        // Use AccountBox component
                        AccountBox(
                          bankName: 'BANK 01',
                          amount: '450,000',
                          accountNumber: '5283 2548 4700 2489',
                          onTap: () {
                            print("BANK 01 tapped");
                          },
                        ),
                        AccountBox(
                          bankName: 'BANK 02',
                          amount: '97,000',
                          accountNumber: '5283 2548 4700 2489',
                          onTap: () {
                            print("BANK 02 tapped");
                          },
                        ),
                        AccountBox(
                          bankName: 'BANK 03',
                          amount: '450,000',
                          accountNumber: '5283 2548 4700 2489',
                          onTap: () {
                            print("BANK 03 tapped");
                          },
                        ),
                        AccountBox(
                          bankName: 'BANK 04',
                          amount: '97,000',
                          accountNumber: '5283 2548 4700 2489',
                          onTap: () {
                            print("BANK 04 tapped");
                          },
                        ),
                        AccountBox(
                          bankName: 'BANK 05',
                          amount: '450,000',
                          accountNumber: '5283 2548 4700 2489',
                          onTap: () {
                            print("BANK 05 tapped");
                          },
                        ),
                        AccountBox(
                          bankName: 'BANK 06',
                          amount: '97,000',
                          accountNumber: '5283 2548 4700 2489',
                          onTap: () {
                            print("BANK 06 tapped");
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Profile Icon at the top right corner
          const ProfileIcon(),
        ],
      ),
    );
  }
}
