import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_pink_club/core/theme/app_colors.dart';
import 'package:the_pink_club/core/widgets/elite_button.dart';
import 'package:the_pink_club/core/widgets/elite_text_field.dart';
import 'package:the_pink_club/features/auth/presentation/providers/auth_cubit.dart';
import 'package:the_pink_club/features/auth/presentation/providers/auth_state.dart';
import 'package:the_pink_club/l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _genderController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _birthdayController.dispose();
    _genderController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister(AuthCubit cubit) {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.registerPasswordsNotMatch)),
      );
      return;
    }

    cubit.register(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      birthday: _birthdayController.text.trim(),
      gender: _genderController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      password: _passwordController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.registerTitle),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              Navigator.of(context).pop();
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<AuthCubit>();
            final isLoading = state is AuthLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    EliteTextField(
                      controller: _fullNameController,
                      label: l10n.registerFullNameLabel,
                      icon: Icons.person_rounded,
                      validator: (v) =>
                          v == null || v.isEmpty ? l10n.registerFullNameRequired : null,
                    ),
                    EliteTextField(
                      controller: _emailController,
                      label: l10n.registerEmailLabel,
                      icon: Icons.email_rounded,
                      keyboard: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return l10n.registerEmailRequired;
                        }
                        if (!v.contains('@')) {
                          return l10n.registerEmailInvalid;
                        }
                        return null;
                      },
                    ),
                    EliteTextField(
                      controller: _birthdayController,
                      label: l10n.registerBirthdayLabel,
                      icon: Icons.cake_rounded,
                      keyboard: TextInputType.datetime,
                    ),
                    EliteTextField(
                      controller: _genderController,
                      label: l10n.registerGenderLabel,
                      icon: Icons.wc_rounded,
                    ),
                    EliteTextField(
                      controller: _phoneController,
                      label: l10n.registerPhoneLabel,
                      icon: Icons.phone_rounded,
                      keyboard: TextInputType.phone,
                    ),
                    EliteTextField(
                      controller: _addressController,
                      label: l10n.registerAddressLabel,
                      icon: Icons.location_on_rounded,
                      keyboard: TextInputType.streetAddress,
                      maxLines: 2,
                    ),
                    EliteTextField(
                      controller: _passwordController,
                      label: l10n.registerPasswordLabel,
                      icon: Icons.lock_rounded,
                      keyboard: TextInputType.visiblePassword,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return l10n.registerPasswordRequired;
                        }
                        if (v.length < 6) {
                          return l10n.registerPasswordMin;
                        }
                        return null;
                      },
                    ),
                    EliteTextField(
                      controller: _confirmPasswordController,
                      label: l10n.registerConfirmPasswordLabel,
                      icon: Icons.lock_outline_rounded,
                      keyboard: TextInputType.visiblePassword,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return l10n.registerConfirmPasswordRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    EliteButton(
                      label: l10n.registerButton,
                      isLoading: isLoading,
                      onPressed: isLoading ? null : () => _onRegister(cubit),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


