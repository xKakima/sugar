import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar/constants/app_colors.dart';
import 'package:sugar/controller/account_page_controller.dart';
import 'package:sugar/database/account.dart';
import 'package:sugar/widgets/account_box.dart';
import 'package:sugar/widgets/account_page_header.dart';
import 'package:sugar/widgets/notifier.dart';
import 'package:sugar/widgets/numpad.dart';
import 'package:sugar/widgets/plus_button.dart';
import 'package:sugar/widgets/rounded_container.dart';
import 'package:sugar/utils/utils.dart';

class AccountPage extends StatefulWidget {
  final String title;
  final Color headerColor;
  final String userId;

  AccountPage(
      {super.key,
      required this.title,
      required this.headerColor,
      required this.userId});

  final AccountPageController controller = Get.put(AccountPageController());

  AccountBox emptyAccountBox = AccountBox(
    accountName: 'empty',
    amount: '0',
    onTap: () => {},
    isEmpty: true,
  );

  Future<List<AccountBox>?> loadAccounts() async {
    final accounts = await fetchAccounts(userId);

    print('Accounts: $accounts');
    if (accounts!.isEmpty) {
      return [emptyAccountBox];
    }
    // await Future.delayed(
    //     const Duration(milliseconds: 0)); // Simulating API delay
    // return [
    //   AccountBox(
    //     accountName: 'BANK 01',
    //     amount: '450,000',
    //     // accountNumber: '5283 2548 4700 2489',
    //     onTap: () => {
    //       controller.updateAccountAmount('100,000'),
    //       controller.toggleExpanded(),
    //       // controller.updateAccountBox(this)
    //       // nvm should be in database
    //     }, // Toggle state on tap
    //   ),
    //   AccountBox(
    //     accountName: 'BANK 02',
    //     amount: '97,000',
    //     // accountNumber: '5283 2548 4700 2489',
    //     onTap: () => {
    //       controller.updateAccountAmount('100,000'),
    //       controller.toggleExpanded()
    //     },
    //   ),
    // ];
  }

  final List<Color> boxColors = [
    AppColors.accountBoxDefault.color,
    AppColors.accountBox2.color,
    AppColors.accountBox3.color,
    AppColors.accountBox4.color,
    AppColors.accountBox5.color,
    AppColors.accountBox6.color,
  ];

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Trigger animation based on the isExpanded state
    widget.controller.isExpanded.listen((isExpanded) {
      if (isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });

    widget.controller.headerColor.value = widget.headerColor;
  }

  @override
  void dispose() {
    _animationController
        .dispose(); // Dispose of the controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<AccountBox>?>(
        future: widget.loadAccounts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final accounts = snapshot.data!;

          return Obx(() => Stack(
                children: [
                  Container(
                      color: widget
                          .controller.headerColor.value), // Background color
                  _buildHeader(),
                  _buildAnimatedContainer(accounts),
                ],
              ));
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(() => Column(
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
        ));
  }

  Widget _buildAnimatedContainer(List<AccountBox> accounts) {
    return Obx(
      () => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: MediaQuery.of(context).size.height *
              (widget.controller.isExpanded.value
                  ? 0.86
                  : 0.75), // Animate size
          child: RoundedContainer(
              isLarge: true,
              child: widget.controller.isExpanded.value
                  ? _buildExpandedSection(accounts)
                  : _buildAccountGrid(accounts)),
        ),
      ),
    );
  }

  Widget _buildExpandedSection(accounts) {
    return accounts.length == 1
        ? _buildEditAccountSection()
        : _buildEditAmountSection();
  }

  Widget _buildColorContainer(Color color) {
    return GestureDetector(
      onTap: () => {
        widget.controller.headerColor.value = color,
      }, // The onTap callback is triggered when the container is tapped
      child: Container(
        width: 35, // Define the width
        height: 35, // Set height equal to width to make it square
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }

  Widget _buildEditAccountSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.edit_note_rounded),
        SizedBox(height: getHeightPercentage(context, 1.5)),
        Text(
          'ACCOUNT NAME',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: getHeightPercentage(context, 1.5)),
        Text(
          "BANK 01",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: getHeightPercentage(context, 3)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox.shrink(),
          ...widget.boxColors.map((color) {
            return _buildColorContainer(color);
          }),
          SizedBox.shrink(),
        ]),
      ],
    );
  }

  Widget _buildAccountGrid(List<AccountBox> accounts) {
    return Column(
      children: [
        Text(
          'ACCOUNTS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 1.55,
            ),
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              return accounts[index];
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: PlusButton(
            onPressed: () => {
              widget.controller.hideBodyData.value = true,
              widget.controller.toggleExpanded()
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEditAmountSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.edit_note_rounded),
        SizedBox(height: getHeightPercentage(context, 1.5)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LAST MONTH',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 15),
            Text(
              'PHP 370,000',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LAST 2 MONTHS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 15),
            Text(
              'PHP 330,000',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: getHeightPercentage(context, 1.5)),
        Text(
          'EDIT AMOUNT',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: getHeightPercentage(context, 1.5)),
        Text(
          widget.controller.accountAmount.value.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: getHeightPercentage(context, 3)),
        Numpad(
          onValueChanged: widget.controller.updateAccountAmount,
          initialValue: widget.controller.accountAmount.value,
        ),
      ],
    );
  }

  Widget _buildCreateNewAccount() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.edit_note_rounded),
        SizedBox(height: getHeightPercentage(context, 1.5)),
        Text(
          'ADD INITIAL AMOUNT',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: getHeightPercentage(context, 1.5)),
        Text(
          widget.controller.accountAmount.value.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: getHeightPercentage(context, 3)),
        Numpad(
          onValueChanged: widget.controller.updateAccountAmount,
          initialValue: widget.controller.accountAmount.value,
        ),
      ],
    );
  }
}
