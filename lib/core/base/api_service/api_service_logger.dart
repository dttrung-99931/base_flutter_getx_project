import 'package:base_flutter_getx/core/utils/log.dart';
import 'package:get/get.dart';

class ApiServiceLogger extends GetConnect {
  @override
  Future<Response<T>> post<T>(String? url, body,
      {String? contentType,
      Map<String, String>? headers,
      Map<String, dynamic>? query,
      Decoder<T>? decoder,
      Progress? uploadProgress}) async {
    // if (AppConfig.config.logRequest) {
    logRequest(url: url, body: body, query: query, requestType: 'POST');
    // }
    Response<T> response = await super.post(
      url,
      body,
      contentType: contentType,
      headers: headers,
      query: query,
      decoder: decoder,
      uploadProgress: uploadProgress,
    );

    logResponse(response);

    return response;
  }

  @override
  Future<Response<T>> put<T>(String url, body,
      {String? contentType,
      Map<String, String>? headers,
      Map<String, dynamic>? query,
      Decoder<T>? decoder,
      Progress? uploadProgress}) async {
    // if (AppConfig.config.logRequest) {
    logRequest(url: url, body: body, query: query, requestType: 'PUT');
    // }
    Response<T> response = await super.put(
      url,
      body,
      contentType: contentType,
      headers: headers,
      query: query,
      decoder: decoder,
      uploadProgress: uploadProgress,
    );

    logResponse(response);

    return response;
  }

  @override
  Future<Response<T>> delete<T>(
    String url, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
  }) async {
    // if (AppConfig.config.logRequest) {
    logRequest(url: url, body: null, query: query, requestType: 'DELETE');
    // }
    Response<T> response = await super.delete(
      url,
      contentType: contentType,
      headers: headers,
      query: query,
      decoder: decoder,
    );

    logResponse(response);

    return response;
  }

  @override
  Future<Response<T>> get<T>(String url,
      {Map<String, String>? headers,
      String? contentType,
      Map<String, dynamic>? query,
      Decoder<T>? decoder}) async {
    logRequest(url: url, body: '', query: query, requestType: 'GET');

    Response<T> response = await super.get(
      url,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
    );

    logResponse(response);

    return response;
  }

  void logResponse(Response<dynamic> response) {
    logd('  Response');
    logd('    ${response.request?.url}');
    logd('    ${response.bodyString}', maxLength: 1000);
  }

  void logRequest({
    required String? url,
    required body,
    required Map<String, dynamic>? query,
    required String requestType,
  }) {
    logd('  Request: $requestType');
    logd('    $url');
    logd('    Query: $query');
    logd('    Body: $body', maxLength: 1000);
    logd('');
  }
}
