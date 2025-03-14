import 'package:flutter/material.dart';
import 'package:sugar/shared/utils/utils.dart';

class AccountData extends StatelessWidget {
  final String id;
  final String name;
  final String balance;
  final VoidCallback onTap;

  const AccountData(
      {super.key,
      required this.id,
      required this.name,
      required this.balance,
      required this.onTap});

  factory AccountData.fromMap(Map<String, dynamic> data) {
    // Validate required fields
    if (data['id'] == null || data['name'] == null || data['amount'] == null) {
      throw FormatException('Missing required fields in account data');
    }
    return AccountData(
      id: data['id'] ?? 'Unknown ID', // Provide a default value if null
      name: data['name'] ?? 'Unknown Name', // Default to 'Unknown Name'
      balance: (data['amount'] as num?)?.toStringAsFixed(2) ?? '0.00',
      onTap: () {}, // Default no-op callback
    );
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(51), // 0.2 opacity = 51/255
          // Adjust the corner radius for a more rounded look
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Name
            Text(
              name,
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
                  formatStringWithCommas(balance),
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
