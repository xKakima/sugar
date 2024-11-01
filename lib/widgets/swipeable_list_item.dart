import 'package:flutter/material.dart';

class SwipeableListItem extends StatelessWidget {
  final Widget child;
  final VoidCallback onSwipe;
  final Color backgroundColor;

  const SwipeableListItem({
    Key? key,
    required this.child,
    required this.onSwipe,
    this.backgroundColor = Colors.red,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key ?? UniqueKey(),
      background: Container(
        color: backgroundColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onSwipe();
      },
      child: child,
    );
  }
}
