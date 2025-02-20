import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Storage extends GetxService {
  static const _keyToken = 'keyToken';
  static const _keyLanguageCode = 'keyLanguageCode';

  GetStorage get _storage => GetStorage();

  final _tokenStorage = ReadWriteValue<String?>(_keyToken, null);
  String? get token => _tokenStorage.val;
  set token(value) => _tokenStorage.val = value;

  final _languageCodeStorage = ReadWriteValue<String?>(_keyLanguageCode, null);
  String? get languageCode => _languageCodeStorage.val;
  set languageCode(value) => _languageCodeStorage.val = value;

  Future<void> clear() async {
    await _storage.erase();
  }
}

extension TokenStorage on Storage {}
