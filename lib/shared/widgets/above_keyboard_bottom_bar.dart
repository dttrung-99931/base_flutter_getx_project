import 'package:flutter/material.dart';

/// Widget that wraps [Scaffold.bottomNavBar] to raise [Scaffold.bottomNavBar]
/// above the keyboard when the keyboard showing
/// 
/// Note: [Scaffold.resizeToAvoidBottomInset] should be true 
/// and the [Scaffold.body] should contains a scroll view 
class AboveKeyboardBottomBar extends StatelessWidget {
  final Widget child;
  final double yOffsetRaising;

  const AboveKeyboardBottomBar({super.key, 
    required this.child,
    this.yOffsetRaising = 0,
  });

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.of(context).viewInsets.bottom;
    double translateY = inset != 0 ? -(inset + yOffsetRaising) : 0;
    return Transform.translate(
      offset: Offset(0, translateY),
      child: child,
    );
  }
}
