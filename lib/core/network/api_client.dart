import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_pink_club/core/network/app_interceptor.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref);
});

class ApiClient {
  static const _baseUrl = 'https://thepinkclub.net/admin/api/api_secure.php';
  late final Dio dio;
  final Ref ref;

  ApiClient(this.ref) {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
      ),
    );

    dio.interceptors.add(AppInterceptor(ref));
  }

  Future<Response> get(String action) {
    return dio.get('', queryParameters: {
      'action': action,
    });
  }

  Future<Response> post(String action, Map<String, dynamic> body) {
    return dio.post('', queryParameters: {
      'action': action,
    }, data: body);
  }
}
