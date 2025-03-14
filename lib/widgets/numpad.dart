import 'package:flutter/material.dart';
import 'package:sugar/utils/utils.dart';

class Numpad extends StatefulWidget {
  final Function(String) onValueChanged;
  final String initialValue;

  const Numpad({
    super.key,
    required this.onValueChanged,
    this.initialValue = '0',
  });

  @override
  State<Numpad> createState() => _NumpadState();
}

class _NumpadState extends State<Numpad> {
  bool isFirstInput = true;

  @override
  Widget build(BuildContext context) {
    // Keys for the numpad
    final List<List<String>> keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
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
                  print("Key: $key, isFirstInput: $isFirstInput");
                  if (key != '⌫' && isFirstInput) {
                    print("Went hereeeee");
                    setState(() {
                      isFirstInput = false;
                    });
                    widget.onValueChanged(formatStringWithCommas(key));
                    return;
                  }
                  if (key == '⌫') {
                    if (widget.initialValue.length > 1) {
                      String newValue = widget.initialValue
                          .substring(0, widget.initialValue.length - 1);
                      newValue = formatStringWithCommas(newValue);
                      widget.onValueChanged(newValue);
                    } else {
                      setState(() {
                        isFirstInput = true;
                      });
                      widget.onValueChanged('0');
                    }
                  } else {
                    // Clear the initial value on first input
                    String newValue;
                    if (isFirstInput) {
                      newValue = key;
                      setState(() {
                        isFirstInput = false;
                      });
                    } else {
                      newValue = widget.initialValue + key;
                    }
                    newValue = formatStringWithCommas(newValue);
                    widget.onValueChanged(newValue);
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
}
