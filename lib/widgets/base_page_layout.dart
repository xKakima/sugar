import 'package:flutter/material.dart';
import 'package:sugar/widgets/background.dart';
import 'package:sugar/widgets/plus_button.dart';

class BasePageLayout extends StatelessWidget {
  final Widget child;
  final bool showHeader;
  final bool showFooter;
  final VoidCallback? onFooterButtonPressed;
  final Widget? header;

  const BasePageLayout({
    super.key,
    required this.child,
    this.showHeader = true,
    this.showFooter = false,
    this.onFooterButtonPressed,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Stack(
        children: [
          Column(
            children: [
              if (showHeader && header != null)
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: header!,
                ),
              Expanded(child: child),
            ],
          ),
          if (showFooter)
            Positioned(
              bottom: 16.0,
              left: 0,
              right: 0,
              child: Center(child: Footer(onPressed: onFooterButtonPressed)),
            ),
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
