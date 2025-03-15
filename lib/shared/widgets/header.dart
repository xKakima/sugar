import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String? title;
  final Widget? leading;
  final Widget? trailing;
  final List<Widget>? actions;
  final Widget? subtitle;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsets padding;

  const Header({
    super.key,
    this.title,
    this.leading,
    this.trailing,
    this.actions,
    this.subtitle,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Row(
            mainAxisAlignment: mainAxisAlignment,
            children: [
              if (leading != null) leading!,
              if (actions != null) ...actions!,
              if (trailing != null) trailing!,
            ],
          ),
          if (title != null) ...[  
            const SizedBox(height: 16),
            Text(
              title!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          if (subtitle != null) ...[  
            const SizedBox(height: 8),
            subtitle!,
          ],
        ],
      ),
    );
  }
}
