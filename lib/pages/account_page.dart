import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar/constants/app_colors.dart';
import 'package:sugar/controller/account_page_controller.dart';
import 'package:sugar/database/account.dart';
import 'package:sugar/utils/constants.dart';
import 'package:sugar/widgets/account_box.dart';
import 'package:sugar/widgets/account_page_header.dart';
import 'package:sugar/widgets/notifier.dart';
import 'package:sugar/widgets/numpad.dart';
import 'package:sugar/widgets/plus_button.dart';
import 'package:sugar/widgets/rounded_container.dart';
import 'package:sugar/utils/utils.dart';

class AccountPage extends StatefulWidget {
  final String title;
  final String headerColor;
  final String userId;
  final bool isUserAccount;

  AccountPage(
      {super.key,
      required this.title,
      required this.headerColor,
      required this.userId,
      required this.isUserAccount});

  final AccountPageController controller = Get.put(AccountPageController());

  final AccountBox emptyAccountBox = AccountBox(
    id: '0',
    accountName: 'empty',
    color: AppColors.accountBoxDefault.color,
    amount: '0',
    onTap: () => {},
    isEmpty: true,
  );

  final List<String> boxColors = [
    AppColors.accountBoxDefault.name,
    AppColors.accountBox2.name,
    AppColors.accountBox3.name,
    AppColors.accountBox4.name,
    AppColors.accountBox5.name,
    AppColors.accountBox6.name,
  ];

  Future<List<AccountBox>?> loadAccounts() async {
    try {
      final response = await fetchAccounts(userId);

      print('Accounts: $response');

      // Return emptyAccountBox list if no accounts were found
      if (response == null || response.isEmpty) {
        print("No accounts found");
        return [emptyAccountBox];
      }

      print("Has accounts");

      var accounts = response
          .map((account) => AccountBox(
                id: account['id'],
                accountName: account['account_name'],
                amount: convertAndFormatToString(account['balance']),
                color: AppColorExtension.fromName(account['color']),
                onTap: () => isUserAccount
                    ? {
                        controller.accountId.value = account['id'],
                        controller.accountAmount.value =
                            convertAndFormatToString(account['balance']),
                        controller.accountName = account['account_name'],
                        controller.setHeaderColor(account['color']),
                        controller.editableAccountTitle.value =
                            account['account_name'],
                        print(
                            "Account Value: ${controller.accountAmount.value}"),
                        print("Account ID: ${controller.accountId.value}"),
                        print(account['id']),
                        controller.editingState.value = EditingState.editAmount,
                        controller.toggleExpanded(),
                      }
                    : {},
              ))
          .toList();

      accounts.add(emptyAccountBox);
      return accounts;
    } catch (error) {
      // Optionally log the error for debugging
      print('Error loading accounts: $error');

      // Re-throw the error so it can be caught in the FutureBuilder
      throw Exception('Failed to load accounts: $error');
    }
  }

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late TextEditingController _accountNameController;
  late Future<List<AccountBox>?> _accountsFuture;
  late String _accountAmount = "0.0";

  Future<void> getAccountBalanceTotal() async {
    final response = await fetchAccountsTotal(widget.isUserAccount);
    _accountAmount = convertAndFormatToString(response);
    print("Account Amount: $_accountAmount");
    setState(() {}); // Call setState to update the UI after fetching the total
  }

  @override
  void initState() {
    super.initState();

    widget.controller.setAccountTitle(widget.title);
    _accountNameController = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animationController.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.completed:
          widget.controller.setBodyData(false);
          break;
        case AnimationStatus.dismissed:
          widget.controller.setBodyData(false);
          break;
        default:
          widget.controller.setBodyData(true);
          break;
      }
    });

    _accountNameController.addListener(() {
      widget.controller.accountName = _accountNameController.text;
    });

    _accountsFuture = widget.loadAccounts(); // Store the future

    // Trigger animation based on the isExpanded state
    widget.controller.isExpanded.listen((isExpanded) {
      if (isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });

    widget.controller.setHeaderColor(widget.headerColor);

    widget.boxColors.forEach((color) {
      print("Color: $color");
    });

    getAccountBalanceTotal();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _accountNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder<List<AccountBox>?>(
        future: _accountsFuture,
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
                    color: widget.controller.isExpanded == false
                        ? AppColorExtension.fromName(widget.headerColor)
                        : AppColorExtension.fromName(
                            widget.controller.accountBoxColor.value),
                  ),
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
                title: widget.controller.editableAccountTitle.value,

                balance: _accountAmount,

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
            child: _buildBodyData(accounts),
          ),
        ),
      ),
    );
  }

  Widget _buildBodyData(accounts) {
    return widget.controller.getBodyData()
        ? const SizedBox()
        : widget.controller.isExpanded.value
            ? _buildEditSection()
            : _buildAccountGrid(accounts);
  }

  Widget _buildEditSection() {
    return Obx(() =>
        widget.controller.editingState.value == EditingState.editAmount
            ? _buildEditAmountSection()
            : _buildEditAccountSection());
  }

  Widget _buildColorContainer(String color) {
    return GestureDetector(
      onTap: () => {
        widget.controller.accountBoxColor.value = color,
      }, // The onTap callback is triggered when the container is tapped
      child: Container(
        width: 35, // Define the width
        height: 35, // Set height equal to width to make it square
        decoration: BoxDecoration(
          color: AppColorExtension.fromName(color),
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }

  Widget _buildEditAccountSection() {
    _accountNameController.text = widget.controller.accountName;
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
        SizedBox(
          width: getWidthPercentage(context, 60),
          child: TextField(
            controller: _accountNameController,
            decoration:
                InputDecoration(hintText: 'BANK 01', border: InputBorder.none),
            style: const TextStyle(color: Colors.white, fontSize: 36),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: getHeightPercentage(context, 3)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          SizedBox(width: getWidthPercentage(context, 10)),
          ...widget.boxColors.map((color) {
            return _buildColorContainer(color);
          }),
          SizedBox(width: getWidthPercentage(context, 10)),
        ]),
        SizedBox(height: getHeightPercentage(context, 30)),
        Align(
          alignment: Alignment.bottomCenter,
          child: IconButton(
              icon: const Icon(Icons.check_box, color: Colors.white, size: 50),
              onPressed: () async {
                final response =
                    await upsertAccount(widget.controller.getNewAccountData());
                print('Response: $response');
                if (response['success']) {
                  setState(() {
                    _accountsFuture = widget.loadAccounts();
                    getAccountBalanceTotal();
                  });
                  widget.controller.toggleExpanded();
                } else {
                  Notifier.show("Failed to add account, kindly try again", 1);
                }
              }),
        ),
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
        widget.userId == supabase.auth.currentUser!.id
            ? Align(
                alignment: Alignment.bottomCenter,
                child: PlusButton(
                  onPressed: () => {
                    widget.controller.editingState.value =
                        EditingState.editAmount,
                    widget.controller.toggleExpanded()
                  },
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Widget _buildEditAmountSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        widget.controller.isNewAccount()
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: getWidthPercentage(context, 10)),
                  Icon(Icons.edit_note_rounded),
                  Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () async {
                          // Add your click action here
                          final response = await deleteAccount(
                              widget.controller.accountId.value);
                          if (response) {
                            setState(() {
                              _accountsFuture = widget.loadAccounts();
                              getAccountBalanceTotal();
                            });
                            widget.controller.setBackToMainTitle();
                            widget.controller.toggleExpanded();
                          } else {
                            Notifier.show(
                                "Failed to delete account, kindly try again",
                                1);
                          }
                        },
                        child: Icon(Icons.delete),
                      ))
                ],
              )
            : Icon(Icons.edit_note_rounded),
        SizedBox(height: getHeightPercentage(context, 1.5)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  'LAST 2 MONTHS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(width: getWidthPercentage(context, 10)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PHP 370,000', //TODO get actual value if account is not empty
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  'PHP 330,000', //TODO get actual value if account is not empty
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
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
            fontSize: 36,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: getHeightPercentage(context, 3)),
        Numpad(
          onValueChanged: widget.controller.updateAccountAmount,
          initialValue: widget.controller.accountAmount.value,
        ),
        SizedBox(height: getHeightPercentage(context, 5)),
        Align(
          alignment: Alignment.bottomCenter,
          child: PlusButton(
            onPressed: () => {
              print("Edit State: ${widget.controller.editingState.value}"),
              widget.controller.editingState.value = EditingState.editAccount,
              print("Edit State: ${widget.controller.editingState.value}"),
              // widget.controller.hideBodyData.value = true,
              // widget.controller.toggleExpanded()
            },
          ),
        ),
      ],
    );
  }
}
