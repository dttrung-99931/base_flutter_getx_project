import 'package:base_flutter_getx/features/settings/controller.dart';
import 'package:get/get.dart';
import 'controller.dart';
import 'core/utils/error_handler/error_report_service.dart';

class GlobalBinding extends Bindings {
  // Provide dependencies used before GetMaterialApp created
  @override
  Future<void> dependencies() async{
    Get.put(ErrorReportService());

    Get.put(MainController());
    await Get.putAsync(SettingController.create);
  }
}
