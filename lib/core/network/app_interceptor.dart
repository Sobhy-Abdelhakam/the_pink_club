import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AppInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // Common headers
    options.headers.addAll({
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    });

    if (kDebugMode) {
      debugPrint('➡️ REQUEST');
      debugPrint('URL: ${options.uri}');
      debugPrint('METHOD: ${options.method}');
      debugPrint('HEADERS: ${options.headers}');
      debugPrint('BODY: ${options.data}');
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      debugPrint('✅ RESPONSE');
      debugPrint('URL: ${response.requestOptions.uri}');
      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('DATA: ${response.data}');
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      debugPrint('❌ ERROR');
      debugPrint('URL: ${err.requestOptions.uri}');
      debugPrint('MESSAGE: ${err.message}');
      debugPrint('RESPONSE: ${err.response?.data}');
    }

    // You can map errors here later
    super.onError(err, handler);
  }
}
