import 'dart:developer';
import 'dart:math' as math;

void loge(Object e, {int? maxLength}) {
  log('ERROR: ${cutString(e.toString(), maxLength)}');
}

void logd(Object e, {int? maxLength}) {
  log(cutString(e.toString(), maxLength));
}

String cutString(String str, int? maxLength) {
  if (maxLength == null) return str;
  String cutted = str.substring(0, math.min(str.length, 1000));
  String continueDots = cutted.length < str.length ? '.....' : '';
  return cutted + continueDots;
}
