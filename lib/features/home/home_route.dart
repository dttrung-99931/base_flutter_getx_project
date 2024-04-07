import 'package:base_flutter_getx/features/home/home_controller.dart';
import 'package:get/get.dart';
import '../../config/routes.dart';
import 'home_screen.dart';

final homeRoute = GetPage(
  name: Routes.home,
  page: () => const HomeScreen(),
  binding: BindingsBuilder.put(() => HomeController()),
);
