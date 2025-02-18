import 'package:get/get.dart';

// Navigate to a route relatively
void toNamedRelative(String routeName, {dynamic arguments}) {
  if (Get.currentRoute != '/') {
    Get.toNamed(Get.currentRoute + routeName, arguments: arguments);
  } else {
    Get.toNamed(routeName, arguments: arguments);
  }
}
