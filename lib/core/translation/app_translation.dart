import 'dart:ui';

import 'package:base_flutter_getx/core/translation/vi.dart';
import 'package:get/get.dart';

import 'en.dart';

class AppTranslation extends Translations {
  static const langeCodeEn = 'en';
  static const langCodeVi = 'vi';
  static const supportedLocales = [
    Locale(langeCodeEn, 'US'),
    Locale(langCodeVi, 'VN'),
  ];
  static const languages = {langeCodeEn: 'Tiếng việt', langCodeVi: 'English'};

  /// Return Locale of languageCode
  /// Return null if the no supported locale for [languageCode] found
  static Locale? localeOf(String languageCode) {
    return supportedLocales.firstWhereOrNull(
      (Locale element) => element.languageCode == languageCode,
    );
  }

  static Locale getDefaultLocale() {
    return Get.deviceLocale != null
        ? localeOf(Get.deviceLocale!.languageCode) ?? supportedLocales.first
        : supportedLocales.first;
  }


  static void changeLocale(Locale locale) {
    Get.updateLocale(locale);
  }

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en,
        'vi_VN': vi,
      };
}
