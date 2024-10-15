import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar/constants/app_colors.dart';
import 'package:sugar/widgets/account_box.dart';
import 'package:sugar/widgets/background.dart';
import 'package:sugar/widgets/balance_box.dart';
import 'package:sugar/widgets/plus_button.dart';
import 'package:sugar/widgets/profile_icon.dart';
import 'package:sugar/controller/data_store_controller.dart';
import 'package:sugar/pages/account_page.dart';
import 'package:sugar/widgets/skeleton_loader.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dataStore = Get.find<DataStoreController>();
  late String sweetFundsBalance = dataStore.getData("sweetFundsBalance");
  late String welcomeText =
      dataStore.getData("userType") == "DADDY" ? "Hi, Daddy!" : "Hi, Baby!";

  Future<dynamic> fetchAccounts() async {
    // Simulate a delay or replace with your API/database query logic
    await Future.delayed(const Duration(seconds: 3));
    return [
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
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Background(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row with Date and Profile Icon
                    SizedBox(
                      width: double.infinity, // Constrain Row width properly
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Mon, 22 September 2024',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14,
                            ),
                          ),
                          ProfileIcon(),
                        ],
                      ),
                    ),
                    // Welcome Text
                    Text(
                      welcomeText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: const Text(
                        "Budget",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // Balance Box for Sweet Funds
                    BalanceBox(
                        title: 'sugar funds',
                        amount: sweetFundsBalance,
                        onTap: () => print("OPEN ACCOUNT"),
                        color: AppColors.defaultBalance.color),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: const Text(
                        "Balance",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        //TODO Dynamic Data
                        BalanceBox(
                          title: 'sugar baby balance',
                          amount: '0',
                          onTap: () => Get.to(() => SkeletonLoader(
                                loadData: fetchAccounts,
                                buildPage: (data) => AccountPage(
                                  title: 'sugar baby balance',
                                  accounts: data,
                                ),
                              )),
                          color: AppColors.sugarBabyBalance.color,
                        ),
                        const SizedBox(height: 8),
                        BalanceBox(
                          title: 'sugar daddy balance',
                          amount: '600,000',
                          onTap: () => Get.to(() => SkeletonLoader(
                                loadData: fetchAccounts,
                                buildPage: (data) => AccountPage(
                                  title: 'sugar baby balance',
                                  accounts: data,
                                ),
                              )),
                          color: AppColors.sugarDaddyBalance.color,
                          hasNoLink: true,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),

                    // Spacer to push the PlusButton to the bottom
                    const Spacer(),

                    // Plus Button Positioned at the Bottom
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: PlusButton(
                        onPressed: () => print("ADD ACCOUNT"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
