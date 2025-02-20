import 'package:base_flutter_getx/features/short_videos/controllers/short_videos_controller.dart';
import 'package:base_flutter_getx/features/short_videos/screens/services/short_videos_service.dart';
import 'package:get/get.dart';

import '../../config/routes.dart';
import 'screens/short_videos_screen.dart';

final shortVideosRoute = GetPage(
  name: Routes.shortVideos,
  page: () => ShortVideosScreen(),
  binding: BindingsBuilder(() {
    Get.lazyPut(() => ShortVideosService());
    Get.lazyPut(() => ShortVideosController());
  }),
);
