import 'package:get/get.dart';

import '../../core/base/base_controller.dart';

class HomeController extends BaseController {
  final counter = RxInt(0);

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  void increase() async {
    counter.value++;
  }

  void decrease() async {
    counter.value--;
  }
}
