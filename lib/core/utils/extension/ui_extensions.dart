import 'package:flutter/material.dart';

extension TextStyleExt on TextStyle? {
  TextStyle light() => this!.copyWith(fontWeight: FontWeight.w300);
  TextStyle regular() => this!.copyWith(fontWeight: FontWeight.w400);
  TextStyle bold() => this!.copyWith(fontWeight: FontWeight.bold);
  TextStyle semibold() => this!.copyWith(fontWeight: FontWeight.w600);

  // TextStyle arial() => this!.copyWith(fontFamily: 'Arial');
  // TextStyle notoSansJP() => this!.copyWith(fontFamily: 'NotoSansJP');

  TextStyle withColor(Color color) => this!.copyWith(color: color);
  TextStyle withSize(double fontSize) => this!.copyWith(fontSize: fontSize);
  TextStyle withHeight(double height) => this!.copyWith(height: height);
  TextStyle withWeight(FontWeight fw) => this!.copyWith(fontWeight: fw);
  TextStyle spacing(double spacing) => this!.copyWith(letterSpacing: spacing * 0);
  TextStyle overflowElipse() => this!.copyWith(overflow: TextOverflow.ellipsis);
  TextStyle withOpacity(double opacity) => this!.copyWith(
        color: this!.color!.withOpacity(opacity),
      );
}
