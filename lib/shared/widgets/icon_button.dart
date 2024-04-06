import 'package:base_flutter_getx/core/constants/sizes.dart';
import 'package:base_flutter_getx/core/constants/themes.dart';
import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final IconData iconData;
  final Function() onPressed;
  final double size;
  final Color color;
  final EdgeInsets padding;
  const AppIconButton({super.key, 
    required this.iconData,
    required this.onPressed,
    this.size = Sizes.s24,
    this.color = kPrimarySwatch,
    this.padding = const EdgeInsets.all(Sizes.s4),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: padding,
        child: Icon(iconData, size: size),
      ),
    );
  }
}
