// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ShortVideoDto {
  final int position;
  final String title;
  final String source;
  final List<String> extensions;
  final String profileName;
  final String clip;
  final String thumbnail;
  final String link;

  ShortVideoDto({
    required this.position,
    required this.title,
    required this.source,
    required this.extensions,
    required this.profileName,
    required this.clip,
    required this.thumbnail,
    required this.link,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'position': position,
      'title': title,
      'source': source,
      'extensions': extensions,
      'profileName': profileName,
      'clip': clip,
      'thumbnail': thumbnail,
      'link': link,
    };
  }

  factory ShortVideoDto.fromMap(Map<String, dynamic> map) {
    return ShortVideoDto(
      position: map['position'] as int,
      title: map['title'] as String,
      source: map['source'] as String,
      extensions: (map['extensions'] as List<String>),
      profileName: map['profileName'] as String,
      clip: map['clip'] as String,
      thumbnail: map['thumbnail'] as String,
      link: map['link'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShortVideoDto.fromJson(String source) =>
      ShortVideoDto.fromMap(json.decode(source) as Map<String, dynamic>);
}
