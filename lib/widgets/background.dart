import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // Wrapping the content with SafeArea
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1F1F1F), // Background color based on HSB values
        ),
        child: child, // The content inside the background
      ),
    );
  }
}
