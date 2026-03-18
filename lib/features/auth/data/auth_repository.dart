import 'package:dio/dio.dart';
import 'package:the_pink_club/core/cache/cache_service.dart';

import 'models/user_model.dart';

class AuthRepository {
  static const String _userCacheKey = 'current_user';

  final Dio _dio;
  final CacheService _cache;

  AuthRepository(this._dio, this._cache);

  // ================== 🔥 Helpers ==================

  String _extractMessage(dynamic data, {String fallback = 'Something went wrong'}) {
    if (data is Map) {
      return data['message']?.toString() ??
          data['error']?.toString() ??
          fallback;
    }
    return fallback;
  }

  Map<String, dynamic> _parseResponse(Response response) {
    final raw = response.data;

    if (raw is! Map) {
      throw Exception('Unexpected response format from server');
    }

    return Map<String, dynamic>.from(raw);
  }

  Never _handleDioError(DioException e, {String fallback = 'Network error'}) {
    final data = e.response?.data;

    final message = _extractMessage(data, fallback: fallback);
    throw Exception(message);
  }


  // ================== 🔐 Auth ==================

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        'login.php',
        data: {'email': email, 'password': password},
      );

      final data = _parseResponse(response);

      if (data['success'] != true) {
        throw Exception(_extractMessage(data, fallback: 'Login failed'));
      }

      final userField = data['user'];
      if (userField is! Map) {
        throw Exception('Missing user data in response');
      }

      final user = UserModel.fromJson(Map<String, dynamic>.from(userField));

      await _cache.put<Map<String, dynamic>>(_userCacheKey, user.toJson());

      return user;
    } on DioException catch (e) {
      _handleDioError(e, fallback: 'Login failed');
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String birthday,
    required String gender,
    required String phoneNumber,
    required String address,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await _dio.post(
        'register.php',
        data: {
          'full_name': fullName,
          'email': email,
          'birthday': birthday,
          'gender': 'Female',
          'phone_number': phoneNumber,
          'address': address,
          'password': password,
          'confirm_password': confirmPassword,
        },
      );

      final raw = response.data;

      // backend ممكن يرجع string
      if (raw is! Map) return;

      final data = Map<String, dynamic>.from(raw);

      if (data['success'] != true) {
        throw Exception(_extractMessage(data, fallback: 'Registration failed'));
      }
    } on DioException catch (e) {
      _handleDioError(e, fallback: 'Registration failed');
    }
  }

  // ================== 🔁 Reset Password ==================

  Future<void> requestOtp(String email) async {
    try {
      final response = await _dio.post(
        'request_password_reset.php',
        data: {'email': email},
      );

      final data = _parseResponse(response);

      if (data['success'] != true) {
        throw Exception(_extractMessage(data, fallback: 'OTP request failed'));
      }
    } on DioException catch (e) {
      _handleDioError(e, fallback: 'OTP request failed');
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    try {
      final response = await _dio.post(
        'verify_reset_otp.php',
        data: {'email': email, 'otp': otp},
      );

      final data = _parseResponse(response);

      if (data['success'] != true) {
        throw Exception(_extractMessage(data, fallback: 'OTP verification failed'));
      }
    } on DioException catch (e) {
      _handleDioError(e, fallback: 'OTP verification failed');
    }
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await _dio.post(
        'reset_password.php',
        data: {
          'email': email,
          'otp': otp,
          'password': newPassword,
          'confirm_password': confirmPassword,
        },
      );

      final data = _parseResponse(response);

      if (data['success'] != true) {
        throw Exception(_extractMessage(data, fallback: 'Password reset failed'));
      }
    } on DioException catch (e) {
      _handleDioError(e, fallback: 'Password reset failed');
    }
  }

  // ================== 💾 Cache ==================

  Future<UserModel?> getSavedUser() async {
    final json = await _cache.get<Map>(_userCacheKey);
    if (json == null) return null;
    return UserModel.fromJson(Map<String, dynamic>.from(json));
  }

  Future<void> logout() async {
    await _cache.delete(_userCacheKey);
  }
}
