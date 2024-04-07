import 'package:flutter/widgets.dart';

part './icons.dart';
part './images.dart';


  const icons = _Icons();
  const images = _Images();

extension StringAssetExt on String {
  Widget build({double? width, double? height, BoxFit fit = BoxFit.contain}) {
    return Image.asset(
      this,
      width: width,
      height: height,
      fit: fit,
    );
  }
}
