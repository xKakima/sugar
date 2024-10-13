import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar/controller/data_store_controller.dart';
import 'package:sugar/widgets/utils.dart';

class ResetDayUI extends StatefulWidget {
  final VoidCallback onConfirm;

  const ResetDayUI({
    Key? key,
    required this.onConfirm,
  }) : super(key: key);

  @override
  _ResetDayUIState createState() => _ResetDayUIState();
}

class _ResetDayUIState extends State<ResetDayUI> {
  final dataStore = Get.find<DataStoreController>();
  int selectedDay = 1; // Default selected day

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
              // Navigator.pop(context);
              dataStore.setData("monthlyBudgetSelected", false);
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
        // const SizedBox(height: 20),

        // Snapping vertical carousel using ListWheelScrollView
        Stack(children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: getWidthPercentage(context, 60),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: Container(
                    height: 60, // Adjust this height as needed
                    width: 130, // Make it stretch horizontally
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 171, 171, 171)
                            .withOpacity(0.2), // Black color with 20% opacity
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              ]),
          SizedBox(
            height: 120, // Adjust the height to fit the design
            child: ListWheelScrollView.useDelegate(
              itemExtent: 60, // Height of each item to ensure proper snapping
              physics: const FixedExtentScrollPhysics(), // Enables snapping
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedDay = index + 1;
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: getWidthPercentage(context, 65),
                      ),
                      Text(
                        '${index + 1}${getDaySuffix(index + 1)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  );
                },
                childCount: 31, // 31 days for the month
              ),
            ),
          ),
        ]),

        const Spacer(),
        Align(
          alignment: Alignment.center,
          child: IconButton(
            icon: const Icon(Icons.check_circle, color: Colors.white, size: 50),
            onPressed: () {
              print('Selected Reset Day: $selectedDay');
              dataStore.setData("resetDay", selectedDay);
              widget.onConfirm();
            },
          ),
        ),
      ],
    );
  }
}
