import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class Storage extends GetxService {
  static const _keyToken = 'keyToken';
  static const _keyLanguageCode = 'keyLanguageCode';
  static GetStorage  _storage() => GetStorage('AppStorage');

  final _tokenStorage = ReadWriteValue<String?>(_keyToken, null, _storage);
  String? get token => _tokenStorage.val;
  set token(value) => _tokenStorage.val = value;

  final _languageCodeStorage = ReadWriteValue<String?>(_keyToken, null, _storage);
  String? get languageCode => _languageCodeStorage.val;
  set languageCode(value) => _languageCodeStorage.val = value;
}

extension TokenStorage on Storage {


}