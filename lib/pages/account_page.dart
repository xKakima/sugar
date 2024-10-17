import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar/controller/account_page_controller.dart';
import 'package:sugar/widgets/account_box.dart';
import 'package:sugar/widgets/account_page_header.dart';
import 'package:sugar/widgets/rounded_container.dart';

class AccountPage extends StatefulWidget {
  final String title;
  final Color headerColor;

  final AccountPageController controller = Get.put(AccountPageController());

  AccountPage({super.key, required this.title, required this.headerColor});

  Future<List<AccountBox>> fetchAccounts() async {
    await Future.delayed(
        const Duration(milliseconds: 0)); // Simulating API delay
    return [
      AccountBox(
        accountName: 'BANK 01',
        amount: '450,000',
        accountNumber: '5283 2548 4700 2489',
        onTap: () => controller.toggleExpanded(), // Toggle state on tap
      ),
      AccountBox(
        accountName: 'BANK 02',
        amount: '97,000',
        accountNumber: '5283 2548 4700 2489',
        onTap: () => controller.toggleExpanded(), // Toggle state on tap
      ),
    ];
  }

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<AccountBox>>(
        future: widget.fetchAccounts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No accounts available.'));
          }

          final accounts = snapshot.data!;

          return Stack(
            children: [
              Container(
                color: widget
                    .headerColor, // Background color applied to the whole screen
              ),
              Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: AccountPageHeader(
                          title: widget.title,
                          balance: '1,500,000',
                          isExpanded: widget.controller.isExpanded
                              .value, // React to the isExpanded state
                        ),
                      ),
                    ],
                  )),
              Obx(() => Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: MediaQuery.of(context).size.height *
                          (widget.controller.isExpanded.value
                              ? 0.9
                              : 0.8), // Animate size based on state
                      child: RoundedContainer(
                        isLarge: true,
                        child: Column(
                          children: [
                            Text(
                              'ACCOUNTS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Expanded(
                                child: GridView.builder(
                              padding: const EdgeInsets.all(16.0),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16.0,
                                mainAxisSpacing: 16.0,
                                childAspectRatio: 1.55,
                              ),
                              itemCount: accounts.length,
                              itemBuilder: (context, index) {
                                return accounts[index];
                              },
                            )),
                          ],
                        ),
                      ),
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }
}
