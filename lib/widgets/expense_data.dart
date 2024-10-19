import 'package:flutter/material.dart';
import 'package:sugar/widgets/utils.dart';

class ExpenseData extends StatelessWidget {
  final String id;
  final DateTime date;
  final String type;
  final String amount;

  const ExpenseData(
      {super.key,
      required this.id,
      required this.date,
      required this.type,
      required this.amount});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            formattedDate(date: date),
            style: const TextStyle(
                color: Colors.white, fontSize: 8, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      SizedBox(height: getHeightPercentage(context, 1.5)),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            getTypeImageString(type),
            width: 50,
            height: 50,
          ),
          Text(
            amount,
            style: const TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      SizedBox(height: getHeightPercentage(context, 2)),
    ]);
  }
}
