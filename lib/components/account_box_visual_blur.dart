import 'dart:ui';
import 'package:flutter/material.dart';

class AccountBoxBlur extends StatefulWidget {
  final String title;
  final String amount;
  final VoidCallback onTap;

  const AccountBoxBlur({
    super.key,
    required this.title,
    required this.amount,
    required this.onTap,
  });

  @override
  _AccountBoxBlurState createState() => _AccountBoxBlurState();
}

class _AccountBoxBlurState extends State<AccountBoxBlur> {
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
                _isHidden
                    ? ClipRect(
                        child: Stack(
                          children: [
                            BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                              child: Container(
                                width:
                                    120, // Adjust the width to cover the text
                                height:
                                    40, // Adjust the height to cover the text
                                color: Colors.black.withOpacity(0.1),
                              ),
                            ),
                            Text(
                              'PHP ${widget.amount}',
                              style: const TextStyle(
                                color: Colors.transparent,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Text(
                        'PHP ${widget.amount}',
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
