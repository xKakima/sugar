import 'package:flutter/material.dart';
import 'package:sugar/utils/utils.dart';
import 'package:sugar/widgets/profile_icon.dart';

class HomeHeader extends StatelessWidget {
  final String welcomeText;

  const HomeHeader({
    super.key,
    required this.welcomeText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedDate(),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
              const ProfileIcon(),
            ],
          ),
        ),
        Text(
          welcomeText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
