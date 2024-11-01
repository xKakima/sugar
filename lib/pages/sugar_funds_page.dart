import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar/controller/data_store_controller.dart';
import 'package:sugar/controller/sugar_funds_page_controller.dart';
import 'package:sugar/database/budget.dart';
import 'package:sugar/database/expense.dart';
import 'package:sugar/utils/constants.dart';
import 'package:sugar/models/expense_data.dart';
import 'package:sugar/widgets/notifier.dart';
import 'package:sugar/widgets/numpad.dart';
import 'package:sugar/widgets/plus_button.dart';
import 'package:sugar/widgets/rounded_container.dart';
import 'package:sugar/widgets/sugar_funds_page_header.dart';
import 'package:sugar/utils/utils.dart';
import 'package:sugar/widgets/swipeable_list_item.dart';

class SugarFundsPage extends StatefulWidget {
  final String title;
  final Color headerColor;
  final bool fromQuickAddExpense;

  SugarFundsPage(
      {super.key,
      required this.title,
      required this.headerColor,
      this.fromQuickAddExpense = false});

  final SugarFundsPageController controller =
      Get.put(SugarFundsPageController());

  Future<List<ExpenseData>> fetchExpenses() async {
    final response = await getExpenses();
    if (response == null) return [];
    return response
        .map((expense) => ExpenseData(
              id: expense['id'],
              date: DateTime.parse(expense['created_at']),
              type: expense['expense_type'],
              amount: expense['amount'].toString(),
            ))
        .toList();
  }

  final List<String> types = [
    "RAMEN",
    "GROCERY",
    "MEAL",
    "ICE_CREAM",
    "COFFEE",
    "SNACKS",
  ];

  @override
  _SugarFundsPageState createState() => _SugarFundsPageState();
}

class _SugarFundsPageState extends State<SugarFundsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late final _stream;

  void fetchBalance() async {
    String? partnerId = dataStore.getData("partnerId");
    if (partnerId != null) {
      dataStore.sugarFundsBalance.value = await fetchMonthlyBalance(partnerId);
    } else {
      dataStore.sugarFundsBalance.value = await fetchMonthlyBalance(null);
    }
  }

  void addExpenseState() {
    widget.controller.setBodyData(true);
    widget.controller.toggleExpanded();
  }

  @override
  void initState() {
    super.initState();

    String? partnerId = dataStore.getData("partnerId"); // Nullable string

    print("Partner ID: $partnerId");

    if (partnerId == null) {
      _stream = supabase
          .from('expense')
          .stream(primaryKey: ['id'])
          .eq('user_id', supabase.auth.currentUser!.id)
          .order('created_at', ascending: true);
    } else {
      _stream = supabase.from('expense').stream(primaryKey: ['id']).inFilter(
          'user_id', [
        supabase.auth.currentUser!.id,
        partnerId!
      ]).order('created_at', ascending: true);
    }

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

    // Trigger animation based on the isExpanded state
    widget.controller.isExpanded.listen((isExpanded) {
      if (isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });

    if (widget.fromQuickAddExpense) {
      addExpenseState();
    }
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
      body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _stream,
          builder: (context, snapshot) {
            late List<ExpenseData> expenses = [];
            // Handle errors first
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            // Check if the data is still being loaded
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData) {
              print("Snapshot data: ${snapshot.data}");
              expenses = snapshot.data!
                  .map((data) => ExpenseData.fromMap(data))
                  .toList();

              print("fetching balance");
              fetchBalance();
            }

            expenses.sort((a, b) => b.date.compareTo(a.date));

            return Stack(
              children: [
                Container(color: widget.headerColor), // Background color
                _buildHeader(),
                _buildAnimatedContainer(expenses),
              ],
            );
          }),
    );
  }

  Widget _buildHeader() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SugarFundsPageHeader(
                title: widget.title,
                balance: dataStore.sugarFundsBalance.value,
                isExpanded: widget.controller.isExpanded
                    .value, // React to the isExpanded state
              ),
            ),
          ],
        ));
  }

  Widget _buildAnimatedContainer(List<ExpenseData> expenses) {
    return Obx(
      () => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: MediaQuery.of(context).size.height *
              (widget.controller.isExpanded.value
                  ? 0.84
                  : 0.75), // Animate size
          child: RoundedContainer(
              isLarge: true, margin: 0, child: _buildBodyData(expenses)),
        ),
      ),
    );
  }

  Widget _buildBodyData(expenses) {
    return widget.controller.getBodyData()
        ? const SizedBox() // Show an empty widget (can be any other placeholder)
        : widget.controller.isExpanded.value
            ? _buildAddExpenseSection() // Show Add Expense section if expanded
            : _buildExpenses(expenses); // Show expenses if not expanded
  }

  Widget _buildExpenses(List<ExpenseData> expenses) {
    return Stack(
      children: [
        Column(
          children: [
            Text(
              'EXPENSES',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: expenses.isEmpty
                  ? const Center(child: Text('No expenses available.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        return SwipeableListItem(
                          child:
                              expenses[index], // Display the ExpenseData widget
                          onSwipe: () async {
                            final expenseId = expenses[index].id;
                            final deleteSuccessful = await deleteExpense(
                                expenseId); // Perform deletion
                            if (deleteSuccessful) {
                              Notifier.show("Expense deleted", 1);
                            } else {
                              Notifier.show("Failed to delete expense", 1);
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: PlusButton(
            onPressed: () => {
              addExpenseState(),
            },
          ),
        ),
      ],
    );
  }

  Widget buildTypeImageContainer(String type) {
    return GestureDetector(
      onTap: () => {
        widget.controller.updateExpenseType(type),
        Notifier.show("Selected expense type: $type", 1),
      }, // The onTap callback is triggered when the container is tapped
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: widget.controller.expenseType == type
              ? Color.fromARGB(255, 111, 111, 111)
              : Color.fromARGB(255, 52, 52, 52),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Image.asset(
          getTypeImageString(type), // Use your helper function
          width: 35,
          height: 35,
        ),
      ),
    );
  }

  Widget _buildAddExpenseSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: getHeightPercentage(context, 1.5)),
        Text(
          'CATEGORY',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: getHeightPercentage(context, 1.5)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          SizedBox.shrink(),
          ...widget.types.map((type) {
            return buildTypeImageContainer(type);
          }),
          SizedBox.shrink(),
        ]),
        SizedBox(height: getHeightPercentage(context, 2.5)),
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
          widget.controller.expenseAmount.value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: getHeightPercentage(context, 3)),
        Numpad(
          onValueChanged: widget.controller.updateExpenseAmount,
          initialValue: widget.controller.expenseAmount.value,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: IconButton(
              icon: const Icon(Icons.check_box, color: Colors.white, size: 50),
              onPressed: () async {
                final response =
                    await addExpense(widget.controller.getNewExpenseData());
                print('Response: $response');
                if (response['success']) {
                  widget.controller.isExpenseSummed.value = true;
                  widget.controller.toggleExpanded();
                } else {
                  Notifier.show("Failed to add expense, kindly try again", 3);
                }
              }),
        ),
      ],
    );
  }
}
