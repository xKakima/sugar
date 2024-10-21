import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AccountBox extends StatelessWidget {
  final String accountName;
  final String amount;
  // final String accountNumber;
  final VoidCallback onTap;
  final bool isEmpty;

  const AccountBox(
      {super.key,
      required this.accountName,
      required this.amount,
      // required this.accountNumber,
      required this.onTap,
      this.isEmpty = false});

  @override
  Widget build(BuildContext context) {
    return isEmpty ? _buildEmptyAccountBox() : _buildAccountBox();
  }

  Widget _buildEmptyAccountBox() {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color.fromARGB(37, 59, 59, 59),
          // Adjust the corner radius for a more rounded look
          borderRadius: BorderRadius.circular(20),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'add a new account',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ));
  }

  Widget _buildAccountBox() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          // Adjust the corner radius for a more rounded look
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Name
            Text(
              accountName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'PHP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  amount,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
