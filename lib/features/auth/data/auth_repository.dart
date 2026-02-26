import 'package:dio/dio.dart';
import 'package:the_pink_club/core/cache/cache_service.dart';

import 'models/user_model.dart';

class AuthRepository {
  static const String _baseUrl = 'https://thepinkclub.net/admin/api/';
  static const String _userCacheKey = 'current_user';

  final Dio _dio;
  final CacheService _cache;

  AuthRepository(this._dio, this._cache);

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '${_baseUrl}login.php',
      data: {
        'email': email,
        'password': password,
      },
    );

    final data = response.data as Map<String, dynamic>;
    final success = data['success'] == true;

    if (!success) {
      throw Exception(data['message'] ?? 'Login failed');
    }

    final userJson = Map<String, dynamic>.from(data['user'] as Map);
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
      '${_baseUrl}register.php',
      data: {
        'full_name': fullName,
        'email': email,
        'birthday': birthday,
        'gender': gender,
        'phone_number': phoneNumber,
        'address': address,
        'password': password,
        'confirm_password': confirmPassword,
      },
    );

    final data = response.data as Map<String, dynamic>;
    final success = data['success'] == true;

    if (!success) {
      throw Exception(data['message'] ?? 'Registration failed');
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


