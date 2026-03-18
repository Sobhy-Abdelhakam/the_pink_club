import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:the_pink_club/core/navigation/fade_slide_page_route.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/elite_button.dart';
import '../providers/password_reset_cubit.dart';
import '../providers/password_reset_state.dart';
import '../widgets/otp_input.dart';
import '../widgets/password_reset_error_message.dart';
import 'reset_password_screen.dart';
import 'package:the_pink_club/l10n/app_localizations.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;

  const VerifyOtpScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<PasswordResetCubit>();
    cubit.setEmail(widget.email);
  }

  Future<void> _onVerify(BuildContext context) async {
    final cubit = context.read<PasswordResetCubit>();
    await cubit.verifyOtp();
  }

  Future<void> _onResend(BuildContext context) async {
    final cubit = context.read<PasswordResetCubit>();
    cubit.setEmail(widget.email);
    await cubit.requestOtp();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        title: Text(l10n.verifyOtpTitle),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocListener<PasswordResetCubit, PasswordResetState>(
          listenWhen: (previous, current) =>
              previous.verifyStatus != current.verifyStatus &&
              current.verifyStatus == VerifyOtpStatus.success,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.otpVerifiedSuccess)),
            );

            final cubit = context.read<PasswordResetCubit>();
            Navigator.of(context).push(
              fadeSlidePageRoute(
                child: BlocProvider.value(
                  value: cubit,
                  child: ResetPasswordScreen(
                    email: state.email,
                    otp: state.otp,
                  ),
                ),
              ),
            );
          },
          child: BlocBuilder<PasswordResetCubit, PasswordResetState>(
            builder: (context, state) {
              final isVerifyLoading = state.verifyStatus == VerifyOtpStatus.loading;
              final isRequestLoading = state.requestStatus == RequestOtpStatus.loading;
              final otpReady = state.otp.length == 6;

              final canResend =
                  state.resendCountdown == 0 && !isRequestLoading && !isVerifyLoading;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      l10n.verifyOtpSubtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.email,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 4,
                      shadowColor: Colors.black.withAlpha(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.verifyOtpTitle,
                              style: Theme.of(context).textTheme.titleMedium,
                            ).animate().fadeIn(duration: 250.ms),
                            const SizedBox(height: 14),
                            Center(
                              child: OtpInput(
                                enabled: !isVerifyLoading && !isRequestLoading,
                                onChanged: (otp) =>
                                    context.read<PasswordResetCubit>().setOtp(otp),
                              ),
                            ),
                            PasswordResetErrorMessage(
                              errorType: state.verifyErrorType,
                              rawMessage: state.verifyErrorMessage,
                            ),
                            const SizedBox(height: 10),
                            EliteButton(
                              label: l10n.verifyOtpButton,
                              isLoading: isVerifyLoading,
                              onPressed: (isVerifyLoading || !otpReady)
                                  ? null
                                  : () => _onVerify(context),
                            ),
                            const SizedBox(height: 18),
                            Center(
                              child: TextButton(
                                onPressed: canResend
                                    ? () => _onResend(context)
                                    : null,
                                child: Text(
                                  state.resendCountdown > 0
                                      ? l10n.resendOtpInSeconds(state.resendCountdown)
                                      : l10n.resendOtpButton,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: canResend
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                            PasswordResetErrorMessage(
                              errorType: state.requestStatus ==
                                      RequestOtpStatus.failure
                                  ? state.requestErrorType
                                  : null,
                              rawMessage: state.requestErrorMessage,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

