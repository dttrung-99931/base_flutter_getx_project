import 'dart:convert';

class GetShortVideosRequest {
  final String q;
  final String engine;
  final String device;
  final String hl;
  final String gl;
  final String apiKey;

  GetShortVideosRequest({
    required this.q,
    required this.apiKey,
    this.engine = 'google_videos',
    this.device = 'mobile',
    this.hl = 'en',
    this.gl = 'us',
  });

  GetShortVideosRequest copyWith({
    String? q,
    String? engine,
    String? device,
    String? hl,
    String? gl,
    String? apiKey,
  }) {
    return GetShortVideosRequest(
      q: q ?? this.q,
      engine: engine ?? this.engine,
      device: device ?? this.device,
      hl: hl ?? this.hl,
      gl: gl ?? this.gl,
      apiKey: apiKey ?? this.apiKey,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'q': q,
      'engine': engine,
      'device': device,
      'hl': hl,
      'gl': gl,
      'api_key': apiKey,
    };
  }

  factory GetShortVideosRequest.fromMap(Map<String, dynamic> map) {
    return GetShortVideosRequest(
      q: map['q'] as String,
      engine: map['engine'] as String,
      device: map['device'] as String,
      hl: map['hl'] as String,
      gl: map['gl'] as String,
      apiKey: map['api_key'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetShortVideosRequest.fromJson(String source) =>
      GetShortVideosRequest.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GetShortVideosRequest(q: $q, engine: $engine, device: $device, hl: $hl, gl: $gl, api_key: $apiKey)';
  }

  @override
  bool operator ==(covariant GetShortVideosRequest other) {
    if (identical(this, other)) return true;

    return other.q == q &&
        other.engine == engine &&
        other.device == device &&
        other.hl == hl &&
        other.gl == gl &&
        other.apiKey == apiKey;
  }

  @override
  int get hashCode {
    return q.hashCode ^
        engine.hashCode ^
        device.hashCode ^
        hl.hashCode ^
        gl.hashCode ^
        apiKey.hashCode;
  }
}
