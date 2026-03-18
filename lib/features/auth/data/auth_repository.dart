import 'package:dio/dio.dart';
import 'package:the_pink_club/core/cache/cache_service.dart';

import 'models/user_model.dart';

class AuthRepository {
  static const String _userCacheKey = 'current_user';

  final Dio _dio;
  final CacheService _cache;

  AuthRepository(this._dio, this._cache);

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      'login.php',
      data: {'email': email, 'password': password},
    );

    final raw = response.data;
    if (raw is! Map) {
      throw Exception('Unexpected response format from server');
    }

    final data = Map<String, dynamic>.from(raw);
    final success = data['success'] == true;

    if (!success) {
      final message = data['message']?.toString() ?? 'Login failed';
      throw Exception(message);
    }

    final userField = data['user'];
    if (userField is! Map) {
      throw Exception('Missing user data in response');
    }

    final userJson = Map<String, dynamic>.from(userField);
    final user = UserModel.fromJson(userJson);

    await _cache.put<Map<String, dynamic>>(_userCacheKey, user.toJson());

    return user;
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
    final response = await _dio.post(
      'register.php',
      data: {
        'full_name': fullName,
        'email': email,
        'birthday': birthday,
        // 'gender': _normalizeGender(gender),
        'gender': 'Female',
        'phone_number': phoneNumber,
        'address': address,
        'password': password,
        'confirm_password': confirmPassword,
      },
    );

    final raw = response.data;
    if (raw is! Map) {
      // Backend may return plain string on success; treat non-JSON 2xx as success
      return;
    }

    final data = Map<String, dynamic>.from(raw);
    final success = data['success'] == true;

    if (!success) {
      final message = data['message']?.toString() ?? 'Registration failed';
      throw Exception(message);
    }
  }

  Future<void> requestOtp(String email) async {
    final response = await _dio.post(
      'request_password_reset.php',
      data: {'email': email},
    );

    final raw = response.data;
    if (raw is! Map) {
      throw Exception('Unexpected response format from server');
    }

    final data = Map<String, dynamic>.from(raw);
    final success = data['success'] == true;

    if (!success) {
      final message = data['message']?.toString() ?? 'OTP request failed';
      throw Exception(message);
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    final response = await _dio.post(
      'verify_reset_otp.php',
      data: {'email': email, 'otp': otp},
    );

    final raw = response.data;
    if (raw is! Map) {
      throw Exception('Unexpected response format from server');
    }

    final data = Map<String, dynamic>.from(raw);
    final success = data['success'] == true;

    if (!success) {
      final message = data['message']?.toString() ?? 'OTP verification failed';
      throw Exception(message);
    }
  }

  // reset password after OTP verification by sending email, otp, password, and confirm password
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await _dio.post(
      'reset_password.php',
      data: {
        'email': email,
        'otp': otp,
        'password': newPassword,
        'confirm_password': confirmPassword,
      },
    );

    final raw = response.data;
    if (raw is! Map) {
      throw Exception('Unexpected response format from server');
    }

    final data = Map<String, dynamic>.from(raw);
    final success = data['success'] == true;

    if (!success) {
      final message = data['message']?.toString() ?? 'Password reset failed';
      throw Exception(message);
    }
  }

  Future<UserModel?> getSavedUser() async {
    final json = await _cache.get<Map>(_userCacheKey);
    if (json == null) return null;
    return UserModel.fromJson(Map<String, dynamic>.from(json));
  }

  Future<void> logout() async {
    await _cache.delete(_userCacheKey);
  }
}
