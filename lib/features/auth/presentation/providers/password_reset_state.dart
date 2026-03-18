import 'package:equatable/equatable.dart';

enum PasswordResetErrorType {
  invalidEmail,
  wrongOtp,
  expiredOtp,
  tooManyRequests,
  networkFailure,
  unknown,
}

enum RequestOtpStatus { initial, loading, success, failure }
enum VerifyOtpStatus { initial, loading, success, failure }
enum ResetPasswordStatus { initial, loading, success, failure }

class PasswordResetState extends Equatable {
  final String email;
  final String otp;
  final int resendCountdown;

  final RequestOtpStatus requestStatus;
  final PasswordResetErrorType? requestErrorType;
  final String? requestErrorMessage;

  final VerifyOtpStatus verifyStatus;
  final PasswordResetErrorType? verifyErrorType;
  final String? verifyErrorMessage;

  final ResetPasswordStatus resetStatus;
  final PasswordResetErrorType? resetErrorType;
  final String? resetErrorMessage;

  const PasswordResetState({
    required this.email,
    required this.otp,
    required this.resendCountdown,
    required this.requestStatus,
    required this.requestErrorType,
    required this.requestErrorMessage,
    required this.verifyStatus,
    required this.verifyErrorType,
    required this.verifyErrorMessage,
    required this.resetStatus,
    required this.resetErrorType,
    required this.resetErrorMessage,
  });

  const PasswordResetState.initial()
      : email = '',
        otp = '',
        resendCountdown = 0,
        requestStatus = RequestOtpStatus.initial,
        requestErrorType = null,
        requestErrorMessage = null,
        verifyStatus = VerifyOtpStatus.initial,
        verifyErrorType = null,
        verifyErrorMessage = null,
        resetStatus = ResetPasswordStatus.initial,
        resetErrorType = null,
        resetErrorMessage = null;

  PasswordResetState copyWith({
    String? email,
    String? otp,
    int? resendCountdown,
    RequestOtpStatus? requestStatus,
    PasswordResetErrorType? requestErrorType,
    String? requestErrorMessage,
    VerifyOtpStatus? verifyStatus,
    PasswordResetErrorType? verifyErrorType,
    String? verifyErrorMessage,
    ResetPasswordStatus? resetStatus,
    PasswordResetErrorType? resetErrorType,
    String? resetErrorMessage,
  }) {
    return PasswordResetState(
      email: email ?? this.email,
      otp: otp ?? this.otp,
      resendCountdown: resendCountdown ?? this.resendCountdown,
      requestStatus: requestStatus ?? this.requestStatus,
      requestErrorType: requestErrorType,
      requestErrorMessage: requestErrorMessage,
      verifyStatus: verifyStatus ?? this.verifyStatus,
      verifyErrorType: verifyErrorType,
      verifyErrorMessage: verifyErrorMessage,
      resetStatus: resetStatus ?? this.resetStatus,
      resetErrorType: resetErrorType,
      resetErrorMessage: resetErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
        email,
        otp,
        resendCountdown,
        requestStatus,
        requestErrorType,
        requestErrorMessage,
        verifyStatus,
        verifyErrorType,
        verifyErrorMessage,
        resetStatus,
        resetErrorType,
        resetErrorMessage,
      ];
}

