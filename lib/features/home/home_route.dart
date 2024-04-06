import 'package:base_flutter_getx/features/home/home_controller.dart';
import 'package:get/get.dart';
import '../../core/constants/routes.dart';
import 'home_screen.dart';

final homeRoute = GetPage(
  name: RouteNames.home,
  page: () => HomeScreen(),
  binding: BindingsBuilder.put(() => HomeController()),
);
