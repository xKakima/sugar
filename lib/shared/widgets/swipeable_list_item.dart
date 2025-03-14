import 'package:flutter/material.dart';

class SwipeableListItem extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onSwipe;
  final Color backgroundColor;

  const SwipeableListItem({
    super.key,
    required this.child,
    required this.onSwipe,
    this.backgroundColor = Colors.red,
  });

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
      confirmDismiss: (direction) async {
        await onSwipe();
        return false; // Never actually dismiss the item
      },
      child: child,
    );
  }
}
