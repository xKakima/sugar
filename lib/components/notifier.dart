import 'package:flutter/material.dart';

class Notifier {
  static void show(BuildContext context, String message, int duration) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: duration),
      ),
    );
  }
}
