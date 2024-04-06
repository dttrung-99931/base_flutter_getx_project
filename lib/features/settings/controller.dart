import 'package:base_flutter_getx/core/translation/app_translation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/base/base_controller.dart';

class SettingController extends BaseController {
  SettingController._();
  static Future<SettingController> create() async {
    var settingController =  SettingController._();
    await settingController.onInit();
    return settingController;
  }

  static const String keyLanguageCode = 'keyLanguageCode';

  final currentLanguageObs = RxString('');
  String get currentLanguage => currentLanguageObs.value;

  final currentLanguageCodeObs = RxString('');
  String get currentLanguageCode => currentLanguageCodeObs.value;

  late SharedPreferences _pref;

  late Locale _currentLocale;
  Locale get currentLocale => _currentLocale;

  @override
  Future<void> onInit() async {
    _pref = await SharedPreferences.getInstance();
    await _initCurrentLanguage();
    super.onInit();
  }

  /// Init current langage by language code stored in SharedPreferences. 
  /// If there's no stored lanaguage code, then set default language
  Future<void> _initCurrentLanguage() async {
    String? langCode = _pref.getString(keyLanguageCode);
    if (langCode == null){
      langCode = AppTranslation.getDefaultLocale().languageCode;
      await _pref.setString(keyLanguageCode, langCode);
    }
    changeLanguage(langCode);
  }

  /// Change current langage by [langCode]
  /// [langCode] must be supoerted lang code: [AppTranslation.langeCodeEn] or [AppTranslation.langCodeVi]
  void changeLanguage(String langCode) {
    Locale? locale = AppTranslation.localeOf(langCode);
    assert(locale != null, 'Unsupport langage code $langCode');
    _currentLocale = locale!;
    AppTranslation.changeLocale(locale);
    _pref.setString(keyLanguageCode, locale.languageCode);
  }
}
