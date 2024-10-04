import 'package:flutter/material.dart';

class AccountBox extends StatefulWidget {
  final String title;
  final String amount;
  final VoidCallback onTap;

  const AccountBox({
    super.key,
    required this.title,
    required this.amount,
    required this.onTap,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AccountBoxState createState() => _AccountBoxState();
}

class _AccountBoxState extends State<AccountBox> {
  bool _isHidden = false; // Controls whether the text is blurred or not

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap, // Makes the entire box clickable
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                // Show the blurred or visible amount
                Text(
                  _isHidden ? '•••••••' : 'PHP ${widget.amount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(
                _isHidden ? Icons.visibility_off : Icons.visibility,
                color: Colors.white,
              ),
              onPressed: _toggleVisibility,
            ),
          ],
        ),
      ),
    );
  }
}
