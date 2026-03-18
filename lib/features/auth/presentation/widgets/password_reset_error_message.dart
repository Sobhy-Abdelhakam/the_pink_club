import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/password_reset_state.dart';

class PasswordResetErrorMessage extends StatelessWidget {
  final PasswordResetErrorType? errorType;
  final String? rawMessage;
  final EdgeInsetsGeometry padding;

  const PasswordResetErrorMessage({
    super.key,
    required this.errorType,
    required this.rawMessage,
    this.padding = const EdgeInsets.only(top: 8),
  });

  String _localizedMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (errorType) {
      case PasswordResetErrorType.invalidEmail:
        return l10n.invalidEmailError;
      case PasswordResetErrorType.wrongOtp:
        return l10n.wrongOtpError;
      case PasswordResetErrorType.expiredOtp:
        return l10n.expiredOtpError;
      case PasswordResetErrorType.tooManyRequests:
        return l10n.tooManyRequestsError;
      case PasswordResetErrorType.networkFailure:
        return l10n.networkFailureError;
      case PasswordResetErrorType.unknown:
        return rawMessage?.trim().isNotEmpty == true
            ? rawMessage!.trim()
            : l10n.networkFailureError;
      case null:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (errorType == null) return const SizedBox.shrink();
    final message = _localizedMessage(context);
    if (message.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: padding,
      child: Text(
        message,
        style: TextStyle(
          color: AppColors.error,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

