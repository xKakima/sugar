import 'package:flutter/material.dart';
import 'package:sugar/shared/constants/app_colors.dart';

class Background extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const Background({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.background.color,
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: child,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
