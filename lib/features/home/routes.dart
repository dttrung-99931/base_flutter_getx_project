import 'package:get/get.dart';
import '../../core/constants/routes.dart';
import 'binding.dart';
import 'screen.dart';

final homeRoutes = GetPage(
  name: RouteNames.HOME,
  page: () => HomeScreen(),
  binding: HomeBinding(),
);
