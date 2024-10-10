import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sugar/widgets/background.dart';
import 'package:sugar/widgets/balance_box.dart';
import 'package:sugar/widgets/plus_button.dart';
import 'package:sugar/widgets/profile_icon.dart';
import 'package:sugar/widgets/utils.dart';
import 'package:sugar/controller/data_store_controller.dart';
import 'package:sugar/database/balance.dart';
import 'package:sugar/database/budget.dart';
import 'package:sugar/pages/account_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dataStore = Get.find<DataStoreController>();
  late String sweetFundsBalance = dataStore.getData("sweetFundsBalance");
  late String welcomeText =
      dataStore.getData("userType") == "DADDY" ? "Hi, Daddy!" : "Hi, Baby!";
  // final String welcomeText = "MEH";

  // @override
  // void initState() {
  //   super.initState();
  //   sweetFundsBalance
  //   welcomeText =
  //       d
  // }

  // Add dynamic loading from database here

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
                  const SizedBox(height: 40), // Adds some space for top padding
                  Text(
                    'Mon, 22 September 2024',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    welcomeText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BalanceBox(
                    title: 'sweet funds REMAINING',
                    amount: sweetFundsBalance,
                    onTap: () => {print("OPEN ACCOUNT")},
                  ),
                  const Divider(color: Colors.white54),
                  // Make the account boxes scrollable
                  Expanded(
                    child: Column(
                      children: [
                        BalanceBox(
                          title: 'sugar baby balance',
                          amount: '0',
                          onTap: () => Get.to(const AccountPage()),
                        ),
                        BalanceBox(
                          title: 'sugar daddy balance',
                          amount: '600,000',
                          onTap: () => () => Get.to(const AccountPage()),
                          hasNoLink: true,
                        ),
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
