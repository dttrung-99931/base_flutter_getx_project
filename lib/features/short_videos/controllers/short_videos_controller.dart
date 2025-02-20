import 'package:base_flutter_getx/features/short_videos/controllers/models/short_video_model.dart';
import 'package:base_flutter_getx/features/short_videos/screens/services/short_videos_service.dart';
import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';

class ShortVideosController extends BaseController {
  final isLoginSucces = RxBool(false);
  final RxList<ShortVideoModel> shortVideos = <ShortVideoModel>[].obs;
  final ShortVideosService _service = Get.find();

  @override
  void onInit() {
    super.onInit();
    getShorttVideos();
  }

  Future<void> getShorttVideos() {
    return handleServiceResult(
      serviceResult: _service.getShortVideos(q: 'Bùi Anh Tuấn'),
      onSuccess: (result) {
        shortVideos.assignAll(result);
      },
      dtoToModel: ShortVideoModel.fromDtoList,
    );
  }
}
