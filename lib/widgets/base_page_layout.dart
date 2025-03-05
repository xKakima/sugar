import 'package:flutter/material.dart';
import 'package:sugar/widgets/background.dart';
import 'package:sugar/widgets/plus_button.dart';

class BasePageLayout extends StatelessWidget {
  final Widget child;
  final bool showHeader;
  final bool showFooter;
  final VoidCallback? onFooterButtonPressed;

  const BasePageLayout({
    super.key,
    required this.child,
    this.showHeader = true,
    this.showFooter = false,
    this.onFooterButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showHeader)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Header'), // Replace with your actual header
                ),
              const Spacer(),
              if (showFooter)
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Footer(onPressed: onFooterButtonPressed),
                ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  final VoidCallback? onPressed;

  const Footer({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return PlusButton(
      onPressed: onPressed ?? () {},
    );
  }
}
