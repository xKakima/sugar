import 'package:flutter/material.dart';

class PlusButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PlusButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      // Centering the button in the Y-axis
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.transparent, // Set the background to transparent
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(
                16), // Rounded corners similar to the provided image
            border: Border.all(
              color: Colors.white.withOpacity(
                  0.3), // Adding a subtle border to make it visible
              width: 2,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
              size:
                  48, // Ensures that the plus icon is big enough to be visually appealing
            ),
          ),
        ),
      ),
    );
  }
}
