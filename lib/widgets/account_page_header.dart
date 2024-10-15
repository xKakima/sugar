import 'package:flutter/material.dart';
import 'package:sugar/widgets/buttons/back_button.dart';
import 'package:sugar/widgets/profile_icon.dart';

class AccountPageHeader extends StatelessWidget {
  final String title;
  final String balance;

  const AccountPageHeader({
    super.key,
    required this.title,
    required this.balance
  })


  @override
  Widget build(BuildContext context) {
    return 
    Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomBackButton(),
                  Text(
                    'Mon, 22 September 2024',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const ProfileIcon(),
        ],
      );
  }
}