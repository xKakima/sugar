import 'package:flutter/material.dart';
import 'package:sugar/components/background.dart';
import 'package:sugar/pages/home_page.dart';
import 'package:sugar/components/day_picker.dart'; // Import the day picker component

class MonthlyBudget extends StatefulWidget {
  const MonthlyBudget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MonthlyBudgetState createState() => _MonthlyBudgetState();
}

class _MonthlyBudgetState extends State<MonthlyBudget> {
  // Controller to set the default value for budget input field
  final TextEditingController _budgetController =
      TextEditingController(text: '10000');

  // Variable to store selected reset day
  int? _selectedDay;

  void _goToHomePage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Background(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'set your monthly budget',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'this will be a shared\nbudget between you and\nyour sugar baby/daddy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Input field for budget
                TextField(
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Budget',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    prefixIcon:
                        Icon(Icons.account_balance_wallet, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 70),
                // Text for Reset Day
                const Text(
                  'reset day',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                // Day input using GestureDetector
                GestureDetector(
                  onTap: () async {
                    final int? pickedDay = await selectDay(context);
                    if (pickedDay != null && pickedDay != _selectedDay) {
                      setState(() {
                        _selectedDay = pickedDay;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDay == null
                              ? 'Select Day'
                              : 'Day $_selectedDay',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                const Spacer(),
                const SizedBox(height: 30),
                // Check button
                IconButton(
                  icon: const Icon(Icons.check_circle,
                      color: Colors.white, size: 50),
                  onPressed: () => _goToHomePage(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
