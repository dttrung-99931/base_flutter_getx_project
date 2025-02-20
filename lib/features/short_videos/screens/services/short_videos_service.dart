import 'package:base_flutter_getx/config/app_config.dart';
import 'package:base_flutter_getx/core/base/api_service/api_service.dart';
import 'package:base_flutter_getx/core/error/app_error.dart';
import 'package:base_flutter_getx/features/short_videos/screens/services/dtos/get_short_videos_request.dart';
import 'package:base_flutter_getx/features/short_videos/screens/services/dtos/short_video_dto..dart';
import 'package:dartz/dartz.dart';

class ShortVideosService extends ApiService {
  Future<Either<AppError, List<ShortVideoDto>>> getShortVideos({
    required String q,
  }) async {
    return handleResponse(
      responseFuture: get(
        'https://serpapi.com/search.json',
        query: GetShortVideosRequest(
          q: q,
          apiKey: AppConfig.config.serpAPIKey,
        ).toMap(),
        decoder: (data) => data['short_videos']
            .map<ShortVideoDto>((e) => ShortVideoDto.fromMap(e))
            .toList(),
      ),
    );
  }
}
