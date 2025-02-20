import 'package:base_flutter_getx/core/utils/extension/list_extension.dart';

class ResponseWrapper<T> {
  final bool success;
  final int statusCode;
  final String? errorCode;
  final String? message;
  final T? data;

  ResponseWrapper({
    required this.success,
    required this.statusCode,
    this.message,
    this.errorCode,
    required this.data,
  });

  factory ResponseWrapper.emptyResponse(dynamic response) {
    return ResponseWrapper.dataObject(responseJson: response);
  }

  factory ResponseWrapper.dataObject({
    required Map<String, dynamic> responseJson,
    T Function(Map<String, dynamic> data)? dataFromJson,
  }) {
    return ResponseWrapper<T>(
      success: responseJson['success'],
      statusCode: responseJson['statusCode'],
      message: responseJson['message'],
      errorCode: responseJson['errorCode'],
      data: dataFromJson != null && responseJson['data'] != null
          ? responseJson['data'] is Map<String, dynamic>
              ? dataFromJson(responseJson['data'])
              : null
          : null,
    );
  }

  static ResponseWrapper<List<U>> dataList<U>({
    required Map<String, dynamic> responseJson,
    required U Function(Map<String, dynamic> item) itemFromJson,
  }) {
    dynamic dataList = responseJson['data'];
    return ResponseWrapper<List<U>>(
      success: responseJson['success'],
      statusCode: responseJson['statusCode'],
      message: responseJson['message'],
      errorCode: responseJson['errorCode'],
      data: dataList != null
          ? dataList is List<dynamic>
              ? dataList.mapList(
                  (dynamic item) => itemFromJson(item as Map<String, dynamic>))
              : null
          : null,
    );
  }
}
