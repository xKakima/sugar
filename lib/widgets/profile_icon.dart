// profile_icon.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sugar/pages/login_page.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({super.key});

//TODO
  Future<void> _navigateToProfile() async {
    // Handle profile navigation
    _logout();
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clears all stored user data
    await supabase.auth.signOut();
    await GoogleSignIn().signOut(); // Ensure Google session is cleared
    Get.to(() => LoginPage());
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
