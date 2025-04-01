import 'package:flutter/material.dart';

class AnimatedContainerWidget extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double height;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final Duration duration;
  final BoxDecoration? decoration;

  const AnimatedContainerWidget({
    super.key,
    required this.child,
    this.backgroundColor = Colors.black,
    this.height = 0.85,
    this.padding = const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
    this.borderRadius,
    this.duration = const Duration(milliseconds: 300),
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: AnimatedContainer(
        duration: duration,
        height: MediaQuery.of(context).size.height * height,
      decoration: decoration ??
          BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius ??
                const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
          ),
      child: Padding(
        padding: padding,
        child: child,
      ),
      ),
    );
  }
}
