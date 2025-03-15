import 'package:flutter/material.dart';
import 'package:sugar/shared/utils/utils.dart';
import 'package:sugar/shared/widgets/profile_icon.dart';

class SugarFundsHeader extends StatelessWidget {
  final String welcomeText;

  const SugarFundsHeader({
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
                  color: Colors.white.withAlpha(153), // 0.6 opacity = 153/255
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
