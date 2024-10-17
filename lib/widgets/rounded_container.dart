import 'package:flutter/material.dart';
import 'package:sugar/constants/app_colors.dart';
import 'package:sugar/widgets/utils.dart';

class RoundedContainer extends StatelessWidget {
  final Widget child;
  final bool isLarge;

  const RoundedContainer({
    super.key,
    required this.child,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    double containerHeight = isLarge ? 76 : 65;
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(left: 0, right: 0, top: 16, bottom: 0),
      height: getHeightPercentage(
          context, containerHeight), // Adjust height based on screen size
      decoration: BoxDecoration(
        color: AppColors.roundedContainer.color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: child,
    );
  }
}
