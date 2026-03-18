import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/navigation/fade_slide_page_route.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/elite_button.dart';
import '../../../../core/widgets/elite_text_field.dart';
import '../providers/password_reset_cubit.dart';
import '../providers/password_reset_state.dart';
import '../widgets/password_reset_error_message.dart';
import 'verify_otp_screen.dart';
import 'package:the_pink_club/l10n/app_localizations.dart';

class RequestOtpScreen extends StatefulWidget {
  const RequestOtpScreen({super.key});

  @override
  State<RequestOtpScreen> createState() => _RequestOtpScreenState();
}

class _RequestOtpScreenState extends State<RequestOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<PasswordResetCubit>();
    _emailController.text = cubit.state.email;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onSendOtp(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<PasswordResetCubit>();
    cubit.setEmail(_emailController.text.trim());
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
        title: Text(l10n.requestOtpTitle),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocListener<PasswordResetCubit, PasswordResetState>(
          listenWhen: (previous, current) =>
              previous.requestStatus != current.requestStatus &&
              current.requestStatus == RequestOtpStatus.success,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.otpSentSuccess)),
            );

            final cubit = context.read<PasswordResetCubit>();
            Navigator.of(context).push(
              fadeSlidePageRoute(
                child: BlocProvider.value(
                  value: cubit,
                  child: VerifyOtpScreen(email: state.email),
                ),
              ),
            );
          },
          child: BlocBuilder<PasswordResetCubit, PasswordResetState>(
            builder: (context, state) {
              final isLoading = state.requestStatus == RequestOtpStatus.loading;

              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                                l10n.requestOtpSubtitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 18),
                              EliteTextField(
                                controller: _emailController,
                                label: AppLocalizations.of(context)!.loginEmailLabel,
                                icon: Icons.email_rounded,
                                keyboard: TextInputType.emailAddress,
                                validator: (v) {
                                  final value = v?.trim() ?? '';
                                  if (value.isEmpty) {
                                    return l10n.loginEmailRequired;
                                  }
                                  if (!value.contains('@')) {
                                    return l10n.loginEmailInvalid;
                                  }
                                  return null;
                                },
                              ),
                              PasswordResetErrorMessage(
                                errorType: state.requestErrorType,
                                rawMessage: state.requestErrorMessage,
                              ),
                              const SizedBox(height: 10),
                              EliteButton(
                                label: l10n.sendOtpButton,
                                isLoading: isLoading,
                                onPressed: isLoading ? null : () => _onSendOtp(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: 0.05, end: 0),
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

