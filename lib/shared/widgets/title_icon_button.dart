import 'package:base_flutter_getx/core/constants/colors.dart';
import 'package:base_flutter_getx/core/constants/diemsions/dimensions.dart';
import 'package:base_flutter_getx/core/constants/themes.dart';
import 'package:flutter/material.dart';

/// Composed buttton with icon, title 
class TitleIconButton extends StatelessWidget {
  final IconData? iconData;
  final Function() onPressed;
  final double iconSize;
  final Color color;
  final EdgeInsets padding;
  final String title;
  final bool expanded;
  final double iconAndTitleSpace;

  TitleIconButton({super.key, 
    this.iconData,
    required this.title,
    required this.onPressed,
    this.color = AppColors.primary,
    this.expanded = false,
    double? iconSize ,
    EdgeInsets? padding,
    double? iconAndTitleSpace,
  }): 
  iconAndTitleSpace = iconAndTitleSpace ?? w8,
  iconSize  = iconSize ?? s20,
  padding = padding ?? EdgeInsets.all(s4);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
          children: [
            if (iconData != null) Icon(iconData, size: iconSize),
            if (iconData != null) SizedBox(width: iconAndTitleSpace),
            Text(
              title,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
