// profile_icon.dart
import 'package:flutter/material.dart';
import 'package:sugar/shared/utils/utils.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({super.key});

  void _navigateToProfile(BuildContext context) {
    logout();
    // Get.to(() => const SplashScreen());
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: const Text('Work In Progress'),
    //       content: const Text('This feature is still being developed.'),
    //       actions: [
    //         TextButton(
    //           child: const Text('OK'),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: IconButton(
          icon: const Icon(Icons.account_circle, color: Colors.white, size: 50),
          onPressed: () => _navigateToProfile(context),
        ),
      ),
    );
  }
}
