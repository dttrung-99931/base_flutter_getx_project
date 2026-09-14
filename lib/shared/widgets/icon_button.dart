import 'package:base_flutter_getx/core/constants/colors.dart';
import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final IconData iconData;
  final Function() onPressed;
  final double size;
  final Color color;
  final EdgeInsets padding;
  AppIconButton({
    super.key,
    required this.iconData,
    required this.onPressed,
    double? size,
    this.color = AppColors.primary,
    EdgeInsets? padding,
  })  : size = size ?? 4,
        padding = padding ?? const EdgeInsets.all(4);

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
