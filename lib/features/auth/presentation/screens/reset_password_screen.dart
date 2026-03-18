import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/elite_button.dart';
import '../../../../core/widgets/elite_text_field.dart';
import '../providers/password_reset_cubit.dart';
import '../providers/password_reset_state.dart';
import '../widgets/password_reset_error_message.dart';
import 'login_screen.dart';
import 'package:the_pink_club/l10n/app_localizations.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<PasswordResetCubit>();
    cubit.setEmail(widget.email);
    cubit.setOtp(widget.otp);
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onReset(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<PasswordResetCubit>();
    await cubit.resetPassword(
      newPassword: _newPasswordController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        title: Text(l10n.resetPasswordTitle),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocListener<PasswordResetCubit, PasswordResetState>(
          listenWhen: (previous, current) =>
              previous.resetStatus != current.resetStatus &&
              current.resetStatus == ResetPasswordStatus.success,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.passwordResetSuccess)),
            );

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          },
          child: BlocBuilder<PasswordResetCubit, PasswordResetState>(
            builder: (context, state) {
              final isLoading = state.resetStatus == ResetPasswordStatus.loading;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Card(
                      elevation: 4,
                      shadowColor: Colors.black.withAlpha(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.resetPasswordTitle,
                                style: Theme.of(context).textTheme.titleMedium,
                              ).animate().fadeIn(duration: 250.ms),
                              const SizedBox(height: 18),
                              EliteTextField(
                                controller: _newPasswordController,
                                label: l10n.newPasswordLabel,
                                icon: Icons.lock_rounded,
                                keyboard: TextInputType.visiblePassword,
                                obscureText: _obscurePassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded,
                                  ),
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          setState(() {
                                            _obscurePassword = !_obscurePassword;
                                          });
                                        },
                                ),
                                validator: (v) {
                                  final value = v?.trim() ?? '';
                                  if (value.isEmpty) return l10n.fieldRequired;
                                  if (value.length < 6) return l10n.passwordMinError;
                                  return null;
                                },
                              ),
                              const SizedBox(height: 6),
                              EliteTextField(
                                controller: _confirmPasswordController,
                                label: l10n.confirmPasswordLabel,
                                icon: Icons.lock_outline_rounded,
                                keyboard: TextInputType.visiblePassword,
                                obscureText: _obscureConfirmPassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded,
                                  ),
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          setState(() {
                                            _obscureConfirmPassword =
                                                !_obscureConfirmPassword;
                                          });
                                        },
                                ),
                                validator: (v) {
                                  final value = v?.trim() ?? '';
                                  if (value.isEmpty) return l10n.fieldRequired;
                                  final password =
                                      _newPasswordController.text.trim();
                                  if (password != value) {
                                    return l10n.resetPasswordsNotMatch;
                                  }
                                  return null;
                                },
                              ),
                              PasswordResetErrorMessage(
                                errorType: state.resetErrorType,
                                rawMessage: state.resetErrorMessage,
                              ),
                              const SizedBox(height: 10),
                              EliteButton(
                                label: l10n.resetPasswordButton,
                                isLoading: isLoading,
                                onPressed:
                                    isLoading ? null : () => _onReset(context),
                              ),
                            ],
                          ),
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

