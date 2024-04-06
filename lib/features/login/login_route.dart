import 'package:base_flutter_getx/features/login/controllers/login_controller.dart';
import 'package:base_flutter_getx/features/login/services/login_service.dart';
import 'package:get/get.dart';
import '../../core/constants/routes.dart';
import 'screens/login_screen.dart';

final loginRoute = GetPage(
  name: RouteNames.login,
  page: () => LoginScreen(),
  binding: BindingsBuilder(() {
    Get.lazyPut(() => LoginService());
    Get.lazyPut(() => LoginController());
  }),
);
