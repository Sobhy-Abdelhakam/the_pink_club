import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/auth_repository.dart';
import 'password_reset_state.dart';

class PasswordResetCubit extends Cubit<PasswordResetState> {
  final AuthRepository _repository;
  Timer? _resendTimer;

  static const int _resendSeconds = 60;

  PasswordResetCubit(this._repository) : super(const PasswordResetState.initial());

  void setEmail(String email) {
    emit(state.copyWith(email: email.trim()));
  }

  void setOtp(String otp) {
    emit(state.copyWith(otp: otp.trim()));
  }

  void _clearOtpErrors() {
    emit(
      state.copyWith(
        requestErrorType: null,
        requestErrorMessage: null,
        verifyErrorType: null,
        verifyErrorMessage: null,
        resetErrorType: null,
        resetErrorMessage: null,
      ),
    );
  }

  Future<void> requestOtp() async {
    _cancelResendTimer();
    _clearOtpErrors();

    final email = state.email.trim();
    if (email.isEmpty) {
      emit(
        state.copyWith(
          requestStatus: RequestOtpStatus.failure,
          requestErrorType: PasswordResetErrorType.invalidEmail,
          requestErrorMessage: null,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        requestStatus: RequestOtpStatus.loading,
        requestErrorType: null,
        requestErrorMessage: null,
      ),
    );

    try {
      await _repository.requestOtp(email);
      _startResendCountdown();
      emit(state.copyWith(requestStatus: RequestOtpStatus.success));
    } on DioException catch (e) {
      final rawMessage = _dioMessage(e);
      final err = _classifyError(rawMessage);
      _cancelResendTimer();
      emit(
        state.copyWith(
          requestStatus: RequestOtpStatus.failure,
          requestErrorType: err,
          requestErrorMessage: rawMessage,
        ),
      );
    } catch (e) {
      final rawMessage = e.toString();
      final err = _classifyError(rawMessage);
      _cancelResendTimer();
      emit(
        state.copyWith(
          requestStatus: RequestOtpStatus.failure,
          requestErrorType: err,
          requestErrorMessage: rawMessage,
        ),
      );
    }
  }

  Future<void> verifyOtp() async {
    _cancelResendTimer();
    _clearOtpErrors();

    final email = state.email.trim();
    final otp = state.otp.trim();

    if (email.isEmpty || otp.isEmpty) {
      emit(
        state.copyWith(
          verifyStatus: VerifyOtpStatus.failure,
          verifyErrorType: PasswordResetErrorType.unknown,
          verifyErrorMessage: 'Missing required data',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        verifyStatus: VerifyOtpStatus.loading,
        verifyErrorType: null,
        verifyErrorMessage: null,
      ),
    );

    try {
      await _repository.verifyOtp(email, otp);
      emit(state.copyWith(verifyStatus: VerifyOtpStatus.success));
    } on DioException catch (e) {
      final rawMessage = _dioMessage(e);
      final err = _classifyError(rawMessage);
      emit(
        state.copyWith(
          verifyStatus: VerifyOtpStatus.failure,
          verifyErrorType: err,
          verifyErrorMessage: rawMessage,
        ),
      );
    } catch (e) {
      final rawMessage = e.toString();
      final err = _classifyError(rawMessage);
      emit(
        state.copyWith(
          verifyStatus: VerifyOtpStatus.failure,
          verifyErrorType: err,
          verifyErrorMessage: rawMessage,
        ),
      );
    }
  }

  Future<void> resetPassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    _cancelResendTimer();
    _clearOtpErrors();

    emit(
      state.copyWith(
        resetStatus: ResetPasswordStatus.loading,
        resetErrorType: null,
        resetErrorMessage: null,
      ),
    );

    final email = state.email.trim();
    final otp = state.otp.trim();

    try {
      await _repository.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      emit(state.copyWith(resetStatus: ResetPasswordStatus.success));
    } on DioException catch (e) {
      final rawMessage = _dioMessage(e);
      final err = _classifyError(rawMessage);
      emit(
        state.copyWith(
          resetStatus: ResetPasswordStatus.failure,
          resetErrorType: err,
          resetErrorMessage: rawMessage,
        ),
      );
    } catch (e) {
      final rawMessage = e.toString();
      final err = _classifyError(rawMessage);
      emit(
        state.copyWith(
          resetStatus: ResetPasswordStatus.failure,
          resetErrorType: err,
          resetErrorMessage: rawMessage,
        ),
      );
    }
  }

  void _startResendCountdown() {
    _cancelResendTimer();
    int seconds = _resendSeconds;
    emit(state.copyWith(resendCountdown: seconds));

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds--;
      if (seconds <= 0) {
        timer.cancel();
        emit(state.copyWith(resendCountdown: 0));
      } else {
        emit(state.copyWith(resendCountdown: seconds));
      }
    });
  }

  void _cancelResendTimer() {
    _resendTimer?.cancel();
    _resendTimer = null;
  }

  @override
  Future<void> close() {
    _cancelResendTimer();
    return super.close();
  }

  String _dioMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return e.message ?? 'Network error';
  }

  PasswordResetErrorType _classifyError(String rawMessage) {
    final message = rawMessage.toLowerCase();

    if (message.contains('invalid') && message.contains('email')) {
      return PasswordResetErrorType.invalidEmail;
    }

    if ((message.contains('email') || message.contains('mail')) &&
        (message.contains('invalid') || message.contains('not found'))) {
      return PasswordResetErrorType.invalidEmail;
    }

    if (message.contains('otp') &&
        (message.contains('wrong') ||
            message.contains('incorrect') ||
            message.contains('invalid'))) {
      return PasswordResetErrorType.wrongOtp;
    }

    if (message.contains('expired')) {
      return PasswordResetErrorType.expiredOtp;
    }

    if (message.contains('too many') ||
        message.contains('rate') ||
        message.contains('limit') ||
        message.contains('many requests')) {
      return PasswordResetErrorType.tooManyRequests;
    }

    if (message.contains('network') ||
        message.contains('socket') ||
        message.contains('timeout') ||
        message.contains('failed to connect')) {
      return PasswordResetErrorType.networkFailure;
    }

    return PasswordResetErrorType.unknown;
  }
}

