import 'package:base_flutter_getx/features/login/controllers/login_controller.dart';
import 'package:base_flutter_getx/features/login/services/login_service.dart';
import 'package:base_flutter_getx/features/login/services/login_service_impl.dart';
import 'package:base_flutter_getx/shared/services/storage_service.dart';
import 'package:get/get.dart';

import '../../config/routes.dart';
import 'screens/login_screen.dart';

final loginRoute = GetPage(
  name: Routes.login,
  page: () => LoginScreen(),
  binding: BindingsBuilder(() {
    Get.lazyPut<LoginService>(() => LoginServiceImpl());
    Get.lazyPut(
      () => LoginController(
        loginService: Get.find<LoginService>(),
        storage: Get.find<Storage>(),
      ),
    );
  }),
);
