// profile_icon.dart
import 'package:flutter/material.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({super.key});

  void _navigateToProfile() {
    // Handle profile navigation
    print("Navigate to profile");
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 16), // Adjust padding as needed
        child: IconButton(
          icon: const Icon(Icons.account_circle, color: Colors.white, size: 50),
          onPressed: _navigateToProfile,
        ),
      ),
    );
  }
}
