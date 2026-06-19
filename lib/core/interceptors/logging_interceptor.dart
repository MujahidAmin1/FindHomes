import 'dart:developer';

import 'package:dio/dio.dart';

class LoggingInterceptor implements Interceptor{
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log("Error: ${err.message} ${err.requestOptions.uri} ${err.response!.statusCode}");
    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log("Request: ${options.method} ${options.uri} ${options.data}, ${options.headers}");
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("Response: ${response.statusCode} ${response.requestOptions.uri} ${response.data}");
    handler.next(response);
  }
}