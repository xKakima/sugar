import 'package:flutter/material.dart';

class RectangleButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isFullSize;

  const RectangleButton({
    super.key,
    this.text,
    this.icon,
    required this.onPressed,
    this.isFullSize = true,
  }) : assert((text != null && icon == null) || (text == null && icon != null),
            'Provide either text or icon, but not both.');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullSize ? 225 : 50,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Color.fromARGB(255, 92, 131, 116), // Customize color as needed
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        ),
        child: Center(
          child: text != null
              ? Text(
                  text!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                )
              : Icon(
                  icon,
                ),
        ),
      ),
    );
  }
}
