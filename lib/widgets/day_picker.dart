import 'package:flutter/material.dart';

Future<int?> selectDay(BuildContext context) async {
  return await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Select a Day'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(31, (index) {
              final day = index + 1;
              return ListTile(
                title: Text('Day $day'),
                onTap: () {
                  Navigator.pop(context, day); // Return the selected day
                },
              );
            }),
          ),
        ),
      );
    },
  );
}
