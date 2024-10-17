import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon:
            const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 15),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
