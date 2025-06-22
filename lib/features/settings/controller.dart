import 'package:base_flutter_getx/core/translation/app_translation.dart';
import 'package:base_flutter_getx/shared/services/storage_service.dart';
import 'package:flutter/material.dart';

import '../../core/base/base_controller.dart';

class SettingController extends BaseController {
  static const String keyLanguageCode = 'keyLanguageCode';
  final Storage _storage;
  late Locale _currentLocale;
  Locale get currentLocale => _currentLocale;

  SettingController({
    required Storage storage,
  }) : _storage = storage;

  @override
  Future<void> onInit() async {
    await _initCurrentLanguage();
    super.onInit();
  }

  /// Init current langage by language code stored in SharedPreferences.
  /// If there's no stored lanaguage code, then set default language
  Future<void> _initCurrentLanguage() async {
    String langCode =
        _storage.languageCode ?? AppTranslation.getDefaultLocale().languageCode;
    changeLanguage(langCode);
  }

  /// Change current langage by [langCode]
  /// [langCode] must be supoerted lang code: [AppTranslation.langeCodeEn] or [AppTranslation.langCodeVi]
  void changeLanguage(String langCode) {
    Locale? locale = AppTranslation.localeOf(langCode);
    assert(locale != null, 'Unsupport langage code $langCode');
    _currentLocale = locale!;
    AppTranslation.changeLocale(locale);
    _storage.languageCode = locale.languageCode;
  }
}
