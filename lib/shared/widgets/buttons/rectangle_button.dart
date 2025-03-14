import 'package:flutter/material.dart';

class RectangleButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final String? image;
  final VoidCallback onPressed;
  final bool isFullSize;

  const RectangleButton({
    super.key,
    this.text,
    this.icon,
    this.image,
    required this.onPressed,
    this.isFullSize = true,
  }) : assert(
            (text != null && icon == null && image == null) ||
                (text == null && icon != null && image == null) ||
                (text == null && icon == null && image != null),
            'Provide either text, icon, or image, but not multiple.');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullSize ? 225 : 100,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 92, 131, 116),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        ),
        child: Center(
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (text != null) {
      return Text(
        text!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      );
    } else if (icon != null) {
      return Icon(
        icon,
        color: Colors.white, // Customize icon color if needed
        size: 24,
      );
    } else if (image != null) {
      return Image.asset(
        image!,
        width: 24,
        height: 24,
        fit: BoxFit.contain,
      );
    }
    return const SizedBox
        .shrink(); // Return an empty widget if nothing is provided
  }
}
