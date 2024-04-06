import 'package:base_flutter_getx/core/constants/sizes.dart';
import 'package:base_flutter_getx/core/constants/styles.dart';
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

  const TitleIconButton({super.key, 
    this.iconData,
    required this.title,
    required this.onPressed,
    this.iconSize = Sizes.s20,
    this.color = kPrimarySwatch,
    this.padding = const EdgeInsets.all(Sizes.s4),
    this.expanded = false,
    this.iconAndTitleSpace = Sizes.s8,
  });

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
              style: Styles.textTitle.copyWith(
                color: kPrimarySwatch,
              ),
            ),
          ],
        ),
      ),
    );
  }
}