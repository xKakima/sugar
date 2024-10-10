import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sugar/widgets/utils.dart';

class Numpad extends StatelessWidget {
  final Function(String) onValueChanged;
  final String initialValue;

  const Numpad({
    Key? key,
    required this.onValueChanged,
    this.initialValue = '0',
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
                  if (key == '⌫') {
                    if (initialValue.length > 1) {
                      String newValue =
                          initialValue.substring(0, initialValue.length - 1);
                      newValue = formatWithCommas(newValue);
                      onValueChanged(newValue);
                    } else {
                      onValueChanged('0');
                    }
                  } else {
                    String newValue =
                        initialValue == '0' ? key : initialValue + key;
                    newValue = formatWithCommas(newValue);
                    onValueChanged(newValue);
                  }
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

  // Utility function to format numbers with commas and apply a limit of 9 digits
}
