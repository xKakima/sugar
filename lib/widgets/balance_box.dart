import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar/controller/data_store_controller.dart';

class BalanceBox extends StatefulWidget {
  final String title;
  final String amount;
  final VoidCallback onTap;
  final Color color;
  final bool hasNoLink;

  const BalanceBox({
    super.key,
    required this.title,
    required this.amount,
    required this.onTap,
    required this.color,
    this.hasNoLink = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _BalanceBoxState createState() => _BalanceBoxState();
}

class _BalanceBoxState extends State<BalanceBox> {
  final dataStore = Get.find<DataStoreController>();
  late String noLinkedAccountText = dataStore.getData("userType") == "DADDY"
      ? "your sugar baby will appear here"
      : "your sugar daddy will appear here";

  bool _isHidden = false;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Title Text
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14, // Smaller font size
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Visibility Toggle Icon
                IconButton(
                  icon: Icon(
                    _isHidden ? Icons.visibility_off : Icons.visibility,
                    size: 18, // Smaller icon
                    color: Colors.white,
                  ),
                  onPressed: _toggleVisibility,
                ),
              ],
            ),
            // Amount Text
            Row(
              children: [
                const Spacer(),
                Text(
                  _isHidden ? '••••••' : 'PHP ${widget.amount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24, // Smaller font size for amount
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
