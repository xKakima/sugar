import 'package:flutter/material.dart';
import 'package:sugar/constants/app_colors.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight, // Fill the available height
              minWidth: constraints.maxWidth, // Fill the available width
            ),
            child: IntrinsicHeight(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.background.color,
                ),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.max, // Take the full vertical space
                  children: [
                    Expanded(
                      child: child, // Main content to fit within the layout
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
