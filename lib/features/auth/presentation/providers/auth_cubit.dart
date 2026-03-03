import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../../data/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    final user = await _repository.getSavedUser();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final user = await _repository.login(email: email, password: password);
      emit(AuthAuthenticated(user));
    } on DioException catch (e) {
      final data = e.response?.data;
      String message;
      if (data is Map && data['message'] != null) {
        message = data['message'].toString();
      } else {
        message = e.message ?? 'Network error';
      }
      emit(AuthError(message));
    } catch (e) {
      emit(AuthError(e.toString()));
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
    emit(AuthLoading());
    try {
      await _repository.register(
        fullName: fullName,
        email: email,
        birthday: birthday,
        gender: gender,
        phoneNumber: phoneNumber,
        address: address,
        password: password,
        confirmPassword: confirmPassword,
      );
      // After successful registration, directly log in the user
      await login(email: email, password: password);
    } on DioException catch (e) {
      final data = e.response?.data;
      String message;
      if (data is Map && data['message'] != null) {
        message = data['message'].toString();
      } else {
        message = e.message ?? 'Network error';
      }
      emit(AuthError(message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(AuthUnauthenticated());
  }
}


