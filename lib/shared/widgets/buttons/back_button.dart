import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  // Add an optinal CallBack function to the constructor
  final VoidCallback? onPressed;
  const CustomBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon:
            const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 15),
        onPressed: () {
          // Check if onPressed is null
          if (onPressed != null) {
            // Call the function if it is not null
            onPressed!();
          }
          // If onPressed is null, pop the current screen
          else {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
