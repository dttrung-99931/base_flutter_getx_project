// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:base_flutter_getx/features/short_videos/screens/services/dtos/short_video_dto..dart';

class ShortVideoModel {
  final int position;
  final String title;
  final String source;
  final List<String> extensions;
  final String profileName;
  final String clip;
  final String thumbnail;
  final String link;

  ShortVideoModel({
    required this.position,
    required this.title,
    required this.source,
    required this.extensions,
    required this.profileName,
    required this.clip,
    required this.thumbnail,
    required this.link,
  });

  factory ShortVideoModel.fromDto(ShortVideoDto dto) {
    return ShortVideoModel(
      position: dto.position,
      title: dto.title,
      source: dto.source,
      extensions: dto.extensions,
      profileName: dto.profileName,
      clip: dto.clip,
      thumbnail: dto.thumbnail,
      link: dto.link,
    );
  }

  static List<ShortVideoModel> fromDtoList(List<ShortVideoDto> dtos) {
    return dtos.map((dto) => ShortVideoModel.fromDto(dto)).toList();
  }
}
