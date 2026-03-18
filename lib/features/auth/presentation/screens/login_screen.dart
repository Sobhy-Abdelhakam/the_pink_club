import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_pink_club/core/di/service_locator.dart';
import 'package:the_pink_club/core/theme/app_colors.dart';
import 'package:the_pink_club/core/widgets/elite_button.dart';
import 'package:the_pink_club/core/widgets/elite_text_field.dart';
import 'package:the_pink_club/features/auth/data/auth_repository.dart';
import 'package:the_pink_club/features/auth/presentation/providers/auth_cubit.dart';
import 'package:the_pink_club/features/auth/presentation/providers/password_reset_cubit.dart';
import 'package:the_pink_club/features/auth/presentation/providers/auth_state.dart';
import 'package:the_pink_club/features/auth/presentation/screens/register_screen.dart';
import 'package:the_pink_club/features/auth/presentation/screens/request_otp_screen.dart';
import 'package:the_pink_club/features/services/presentation/screens/main_screen.dart';
import 'package:the_pink_club/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin(AuthCubit cubit) {
    if (!_formKey.currentState!.validate()) return;

    cubit.login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const MainScreen()),
                (route) => false,
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            final cubit = context.read<AuthCubit>();
            final isLoading = state is AuthLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    l10n.loginWelcomeTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.loginWelcomeSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
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
                          children: [
                            EliteTextField(
                              controller: _emailController,
                              label: l10n.loginEmailLabel,
                              icon: Icons.email_rounded,
                              keyboard: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return l10n.loginEmailRequired;
                                }
                                if (!v.contains('@')) {
                                  return l10n.loginEmailInvalid;
                                }
                                return null;
                              },
                            ),
                            EliteTextField(
                              controller: _passwordController,
                              label: l10n.loginPasswordLabel,
                              icon: Icons.lock_rounded,
                              keyboard: TextInputType.visiblePassword,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return l10n.loginPasswordRequired;
                                }
                                if (v.length < 6) {
                                  return l10n.loginPasswordMin;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 8),
                            EliteButton(
                              label: l10n.loginButton,
                              isLoading: isLoading,
                              onPressed: isLoading
                                  ? null
                                  : () => _onLogin(cubit),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => BlocProvider(
                                              create: (_) => PasswordResetCubit(
                                                sl<AuthRepository>(),
                                              ),
                                              child: const RequestOtpScreen(),
                                            ),
                                          ),
                                        );
                                      },
                                child: Text(
                                  l10n.forgotPasswordButton,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  l10n.loginNoAccount,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    final authCubit = context.read<AuthCubit>();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider.value(
                                          value: authCubit,
                                          child: const RegisterScreen(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    l10n.loginCreateAccount,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
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
    );
  }
}
