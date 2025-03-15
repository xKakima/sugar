import 'package:flutter/material.dart';
import 'package:sugar/shared/widgets/background.dart';
import 'package:sugar/shared/widgets/plus_button.dart';

enum FooterStyle {
  plus,
  check,
}

class BasePageLayout extends StatelessWidget {
  final Widget child;
  final bool showHeader;
  final bool showFooter;
  final VoidCallback? onFooterButtonPressed;
  final Widget? header;
  final FooterStyle? footerStyle;
  final Color? backgroundColor;

  const BasePageLayout({
    super.key,
    required this.child,
    this.showHeader = true,
    this.showFooter = false,
    this.onFooterButtonPressed,
    this.header,
    this.footerStyle,
    this.backgroundColor,
  }) : assert(
          !showFooter || (showFooter && footerStyle != null),
          'footerStyle must be provided when showFooter is true',
        );

  @override
  Widget build(BuildContext context) {
    return Background(
      backgroundColor: backgroundColor,
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
              child: Center(
                child: Footer(
                  style: footerStyle!,
                  onPressed: onFooterButtonPressed,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  final VoidCallback? onPressed;
  final FooterStyle style;

  const Footer({
    super.key,
    required this.style,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case FooterStyle.plus:
        return PlusButton(
          onPressed: onPressed ?? () {},
        );
      case FooterStyle.check:
        return FloatingActionButton(
          onPressed: onPressed ?? () {},
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.check,
            color: Colors.black,
          ),
        );
    }
  }
}
