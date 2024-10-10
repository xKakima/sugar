import 'package:flutter/material.dart';
import 'package:sugar/widgets/utils.dart';

class ResetDayUI extends StatelessWidget {
  final VoidCallback onConfirm;

  const ResetDayUI({
    Key? key,
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
              'set your\nreset\nday',
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
          children: const [
            Text(
              '15th',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
        const Spacer(),
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
