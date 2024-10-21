import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Numpad extends StatelessWidget {
  final Function(double) onValueChanged;
  final double initialValue;

  const Numpad({
    Key? key,
    required this.onValueChanged,
    this.initialValue = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Keys for the numpad
    final List<List<String>> keys = [
      ['7', '8', '9'],
      ['4', '5', '6'],
      ['1', '2', '3'],
      ['.', '0', '⌫'],
    ];

    // Adjust sizes based on screen width for responsiveness
    double buttonWidth =
        MediaQuery.of(context).size.width * 0.25; // Adjusted width
    double buttonHeight =
        buttonWidth * 0.55; // Keep the height a bit less to make it rectangular
    double buttonSpacing = 8.0; // Space between buttons

    double currentValue = initialValue;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys.map((row) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: buttonSpacing / 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((key) {
              return GestureDetector(
                onTap: () {
                  String newValue = currentValue.toString();

                  if (key == '⌫') {
                    // Handle backspace (⌫) functionality
                    if (newValue.length > 1) {
                      newValue = newValue.substring(0, newValue.length - 1);
                    } else {
                      newValue = '0';
                    }
                    currentValue = double.tryParse(newValue) ?? 0;
                  } else if (key == '.') {
                    // Prevent adding more than one decimal point
                    if (!newValue.contains('.')) {
                      newValue += key;
                      currentValue = double.tryParse(newValue) ?? currentValue;
                    }
                  } else {
                    // Handle number inputs
                    newValue =
                        newValue == '0' && key != '.' ? key : newValue + key;
                    currentValue = double.tryParse(newValue) ?? currentValue;
                  }

                  // Format the value
                  // String formattedValue = _formatWithCommas(currentValue);
                  onValueChanged(currentValue); // Pass the double value

                  print("New value: $currentValue"); // Debugging purpose
                },
                child: Container(
                  width: buttonWidth, // Adjusted width
                  height: buttonHeight, // Adjusted height
                  decoration: BoxDecoration(
                    color:
                        const Color.fromARGB(255, 52, 52, 52), // Button color
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      key,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  // Utility function to format numbers with commas, including decimals
  // String _formatWithCommas(double value) {
  //   return NumberFormat("#,##0.00").format(value);
  // }
}
