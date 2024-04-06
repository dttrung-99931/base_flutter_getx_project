class ResponseWrapper<T> {
  final bool success;
  final int statusCode;
  final String? message;
  final T? data;
  
  ResponseWrapper({
    required this.success,
    required this.statusCode,
    this.message,
    required this.data,
  });

  factory ResponseWrapper.fromMap(Map<String, dynamic> json, T Function(Map<String, dynamic> json) dataFromJson){
    return ResponseWrapper(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? dataFromJson(json['data']) : null, 
      );
  }
}
