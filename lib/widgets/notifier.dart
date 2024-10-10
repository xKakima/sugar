import 'package:get/get.dart';
import 'package:flutter/material.dart';

class Notifier {
  static void show(String message, int duration) {
    Get.snackbar(
      '', // Title (can leave empty if not needed)
      '',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      backgroundColor: const Color(0xFF323232),
      colorText: const Color(0xFFFFFFFF),
      padding: const EdgeInsets.all(10),
      messageText: Center(
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
