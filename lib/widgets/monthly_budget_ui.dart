import 'package:flutter/material.dart';
import 'package:sugar/utils/utils.dart';
import 'package:sugar/widgets/numpad.dart';

class MonthlyBudgetUI extends StatelessWidget {
  final double value;
  final Function(double) onValueChanged;
  final VoidCallback onConfirm;

  const MonthlyBudgetUI({
    Key? key,
    required this.value,
    required this.onValueChanged,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        const SizedBox(height: 50),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: getWidthPercentage(context, 55),
            ),
            const Text(
              'set your\nmonthly\nbudget',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: getWidthPercentage(context, 3),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'PHP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: getWidthPercentage(context, 5),
            ),
            Text(
              convertAndFormatToString(value),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: getWidthPercentage(context, 3),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Numpad(
          onValueChanged: onValueChanged,
          initialValue: value,
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.center,
          child: IconButton(
            icon: const Icon(Icons.check_circle, color: Colors.white, size: 50),
            onPressed: onConfirm,
          ),
        ),
      ],
    );
  }
}
