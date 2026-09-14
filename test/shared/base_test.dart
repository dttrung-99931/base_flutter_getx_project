import 'package:base_flutter_getx/config/app_config.dart';
import 'package:base_flutter_getx/global_binding.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void setUpTest() {
  AppConfig.set(apiUrl: '', flavor: AppFlavor.dev);
  GlobalBinding().dependencies();
  TestWidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;
}
