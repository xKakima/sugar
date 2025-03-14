import 'package:flutter/material.dart';
import 'package:sugar/shared/constants/app_colors.dart';
import 'package:sugar/shared/utils/utils.dart';

class RoundedContainer extends StatelessWidget {
  final Widget child;
  final bool isLarge;
  final double margin;

  const RoundedContainer({
    super.key,
    required this.child,
    this.isLarge = false,
    this.margin = 16,
  });

  @override
  Widget build(BuildContext context) {
    final containerHeight = isLarge ? 76.0 : 65.0;
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: EdgeInsets.only(left: 0, right: 0, top: margin, bottom: 0),
      height: getHeightPercentage(
          context, containerHeight), // Adjust height based on screen size
      decoration: BoxDecoration(
        color: AppColors.roundedContainer.color,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16.0),
          topRight: const Radius.circular(16.0),
          bottomLeft: const Radius.circular(0.0),
          bottomRight: const Radius.circular(0.0),
        ),
      ),
      child: child,
    );
  }
}
