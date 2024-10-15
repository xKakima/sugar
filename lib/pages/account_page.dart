import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar/widgets/account_box.dart';
import 'package:sugar/widgets/background.dart';
import 'package:sugar/widgets/profile_icon.dart';
import 'package:sugar/widgets/buttons/back_button.dart';
import 'package:sugar/controller/data_store_controller.dart';

class AccountPage extends StatefulWidget {
  final String title;
  final List<AccountBox> accounts;

  const AccountPage({super.key, required this.title, required this.accounts});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final dataStore = Get.find<DataStoreController>();
  late String sweetFundsBalance = dataStore.getData("sweetFundsBalance");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Background(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row with Back Button, Date, and Profile Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomBackButton(),
                            // const SizedBox(
                            //     height: 4), // Spacing between back button and date
                            Text(
                              'Mon, 22 September 2024',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const ProfileIcon(),
                  ],
                ),
                const SizedBox(height: 16), // Spacing below the header

                // Title and Amount Section
                Text(
                  'sugar baby balance',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'TOTAL AMOUNT',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'PHP 800,000',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24), // Spacing before account cards

                // Accounts Section
                const Text(
                  'ACCOUNTS',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Grid Layout for Bank Cards
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _buildAccountCard('Union Bank', '450,000', Colors.amber),
                      _buildAccountCard('Bank 02', '97,000', Colors.purple),
                      _buildAccountCard('Bank 03', '450,000', Colors.grey),
                      _buildAccountCard('Bank 04', '97,000', Colors.grey),
                      _buildAccountCard('Bank 03', '450,000', Colors.grey),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to build individual account cards
  Widget _buildAccountCard(String bankName, String amount, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bankName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'PHP $amount',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '5555 4444 3333 8888',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
