import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/background.png', // Ensure the asset path is correct
            fit: BoxFit.cover,
          ),
        ),
        child, // The content inside the background
      ],
    );
  }
}
