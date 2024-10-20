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

  factory ExpenseData.fromMap(Map<String, dynamic> data) {
    print("Parsing Data ${data}");
    print(data['created_at']);
    print(data['expense_type']);
    print(data['amount']);
    print(data['id']);
    return ExpenseData(
      id: data['id'] ?? 'Unknown ID', // Provide a default value if null
      date: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : DateTime.now(), // Provide the current date if null
      type: data['expense_type'] ?? 'Unknown Type', // Default to 'Unknown Type'
      amount: (data['amount'] as num?)?.toStringAsFixed(2) ?? '0.00',
    );
  }
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
