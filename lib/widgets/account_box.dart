import 'package:flutter/material.dart';
import 'package:sugar/constants/app_colors.dart';

class AccountBox extends StatelessWidget {
  final String id;
  final String accountName;
  final String amount;
  final Color color;
  final int index;
  final VoidCallback onTap;
  final bool isEmpty;
  final String previousAmount;

  const AccountBox({
    Key? key,
    required this.id,
    required this.accountName,
    required this.amount,
    required this.color,
    required this.index,
    required this.onTap,
    this.isEmpty = false,
    this.previousAmount = '0',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isEmpty ? _buildEmptyAccountBox() : _buildAccountBox();
  }

  Widget _buildEmptyAccountBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accountBoxDefault.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'Add a new account',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildAccountBox() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
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
