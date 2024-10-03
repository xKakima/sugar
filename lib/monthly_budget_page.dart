import 'package:flutter/material.dart';
import 'package:sugar/components/background.dart';

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

  // Variable to store selected reset date
  DateTime? _selectedDate;

  // Checkbox state
  bool _isChecked = false;

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
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
                // Text for Reset Date
                const Text(
                  'reset date',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                // Date input
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
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
                          _selectedDate == null
                              ? 'Select Date'
                              : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                const Spacer(),
                // Checkbox with confirmation
                // CheckboxListTile(
                //   title: const Text(
                //     'Agree to terms',
                //     style: TextStyle(color: Colors.white),
                //   ),
                //   value: _isChecked,
                //   onChanged: (bool? newValue) {
                //     setState(() {
                //       _isChecked = newValue ?? false;
                //     });
                //   },
                //   controlAffinity: ListTileControlAffinity.leading,
                //   activeColor: Colors.white,
                //   checkColor: Colors.black,
                // ),
                const SizedBox(height: 30),
                // Check button
                IconButton(
                  icon: const Icon(Icons.check_circle,
                      color: Colors.white, size: 50),
                  onPressed: () => print('Budget ni bebi ay galing sa dadi'),
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
