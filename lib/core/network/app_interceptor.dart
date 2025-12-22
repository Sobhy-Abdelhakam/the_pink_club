import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_pink_club/core/providers/locale_provider.dart';

class AppInterceptor extends Interceptor {
  final Ref ref;

  AppInterceptor(this.ref);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final locale = ref.read(localeProvider);
    
    // Common headers
    options.headers.addAll({
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'lang': locale.languageCode,
      'Accept-Language': locale.languageCode,
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
