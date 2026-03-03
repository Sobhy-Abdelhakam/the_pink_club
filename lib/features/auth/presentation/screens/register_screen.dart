import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_pink_club/core/theme/app_colors.dart';
import 'package:the_pink_club/core/widgets/elite_button.dart';
import 'package:the_pink_club/core/widgets/elite_text_field.dart';
import 'package:the_pink_club/features/auth/presentation/providers/auth_cubit.dart';
import 'package:the_pink_club/features/auth/presentation/providers/auth_state.dart';
import 'package:the_pink_club/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

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
  DateTime? _selectedBirthday;
  String? _selectedGender;
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _birthdayController.dispose();
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
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.registerPasswordsNotMatch,
          ),
        ),
      );
      return;
    }

    cubit.register(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      birthday: _birthdayController.text.trim(),
      gender: _selectedGender?.trim() ?? '',
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
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
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
                      validator: (v) => v == null || v.isEmpty
                          ? l10n.registerFullNameRequired
                          : null,
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
                      readOnly: true,
                      validator: (v) =>
                          v == null || v.isEmpty ? l10n.fieldRequired : null,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedBirthday ?? DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          locale: Localizations.localeOf(context),
                        );
                        if (picked != null) {
                          _selectedBirthday = picked;
                          _birthdayController.text = DateFormat(
                            'yyyy-MM-dd',
                          ).format(picked);
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: InputDecoration(
                          labelText: l10n.registerGenderLabel,
                          prefixIcon: Icon(
                            Icons.wc_rounded,
                            color: AppColors.primary.withAlpha(180),
                            size: 20,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: AppColors.divider,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: AppColors.divider,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: AppColors.error,
                              width: 1,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          alignLabelWithHint: true,
                        ),
                        items:
                            [
                                  l10n.genderMale,
                                  l10n.genderFemale,
                                  l10n.genderOther,
                                ]
                                .map(
                                  (g) => DropdownMenuItem(
                                    value: g,
                                    child: Text(g),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) => setState(() {
                          _selectedGender = v;
                        }),
                        validator: (v) =>
                            v == null || v.isEmpty ? l10n.fieldRequired : null,
                      ),
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
