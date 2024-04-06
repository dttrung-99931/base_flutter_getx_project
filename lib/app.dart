// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:base_flutter_getx/core/base/base_get_widget.dart';
import 'package:base_flutter_getx/core/constants/routes.dart';
import 'package:base_flutter_getx/features/settings/controller.dart';
import 'package:base_flutter_getx/core/translation/app_translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'core/constants/constants.dart';
import 'features/home/routes.dart';

class App extends BaseGetWidget<SettingController> {
  final String initialRoute;
  const App({super.key, 
    this.initialRoute = RouteNames.HOME,
  });


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (ctx, child) => GetMaterialApp(
        initialRoute: initialRoute,
        getPages: [
          homeRoutes,
        ],
        defaultTransition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 800),
        debugShowCheckedModeBanner: false,
        theme: kAppTheme,
        // Config translation
        translations: AppTranslation(),
        locale: controller.currentLocale,        
      ),
    );
  }
}
