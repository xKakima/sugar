import 'package:flutter/material.dart';
import 'package:sugar/shared/utils/utils.dart';
import 'package:sugar/shared/widgets/header.dart';
import 'package:sugar/shared/widgets/profile_icon.dart';

class HomeHeader extends StatelessWidget {
  final String welcomeText;

  const HomeHeader({
    super.key,
    required this.welcomeText,
  });

  @override
  Widget build(BuildContext context) {
    return Header(
      title: welcomeText,
      leading: Row(
        children: [
          Image.asset(
            'assets/images/sugar_cube.png',
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 8),
          Text(
            formattedDate(),
            style: TextStyle(
              color: Colors.white.withAlpha(153),
              fontSize: 14,
            ),
          ),
        ],
      ),
      trailing: const ProfileIcon(),
    );
  }
}
