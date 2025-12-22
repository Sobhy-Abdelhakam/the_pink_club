import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_pink_club/core/theme/app_colors.dart';
import 'package:the_pink_club/core/widgets/elite_button.dart';
import 'package:the_pink_club/core/widgets/elite_text_field.dart';
import 'package:the_pink_club/features/subscription/data/models/subscription_package.dart';
import 'package:the_pink_club/features/subscription/presentation/providers/subscription_provider.dart';
import 'package:the_pink_club/l10n/app_localizations.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  final fullNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final carBrandCtrl = TextEditingController();
  final carModelCtrl = TextEditingController();
  final carYearCtrl = TextEditingController();
  final carChassisCtrl = TextEditingController();
  final carPlateCtrl = TextEditingController();

  String gender = 'female';
  String paymentMethod = 'cash';
  SubscriptionPackage? selectedPackage;

  @override
  void dispose() {
    fullNameCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    carBrandCtrl.dispose();
    carModelCtrl.dispose();
    carYearCtrl.dispose();
    carChassisCtrl.dispose();
    carPlateCtrl.dispose();
    super.dispose();
  }

  void _nextStep(AppLocalizations l10n) {
    if (_currentStep == 0 && selectedPackage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectPackageFirst)),
      );
      return;
    }

    if (_currentStep > 0 && !_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _currentStep++);
  }

  void _prevStep() {
    setState(() => _currentStep--);
  }

  @override
  Widget build(BuildContext context) {
    final packagesAsync = ref.watch(subscriptionPackagesProvider);
    final l10n = AppLocalizations.of(context)!;

    ref.listen(subscriptionProvider, (prev, next) {
      next.whenOrNull(
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.membershipSuccess),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
        },
        error: (e, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.exclusiveMembership),
        centerTitle: true,
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: _prevStep,
              )
            : null,
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          letterSpacing: 0.5,
        ),
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: AnimatedSwitcher(
              duration: 400.ms,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.05, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _buildStepContent(packagesAsync, l10n),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 20, horizontal: 40),
      child: Row(
        children: List.generate(3, (index) {
          final isActive = index <= _currentStep;
          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : AppColors.divider,
                    shape: BoxShape.circle,
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withAlpha(20),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : null,
                  ),
                  child: Center(
                    child: index < _currentStep
                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: isActive ? Colors.white : AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                  ),
                ),
                if (index < 2)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                      color: index < _currentStep ? AppColors.primary : AppColors.divider,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepContent(AsyncValue<List<SubscriptionPackage>> packagesAsync, AppLocalizations l10n) {
    switch (_currentStep) {
      case 0:
        return _buildPackageStep(packagesAsync, l10n);
      case 1:
        return _buildIdentityStep(l10n);
      case 2:
        return _buildVehicleStep(l10n);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPackageStep(AsyncValue<List<SubscriptionPackage>> packagesAsync, AppLocalizations l10n) {
    return SingleChildScrollView(
      key: const ValueKey(0),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.choosePrivilege,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.choosePackageDesc,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withAlpha(200),
            ),
          ),
          const SizedBox(height: 24),
          packagesAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (err, _) => Center(child: Text('Error: $err')),
            data: (packages) => Column(
              children: packages.map((pkg) => _buildPackageCard(pkg)).toList(),
            ),
          ),
          const SizedBox(height: 24),
          EliteButton(
            label: l10n.continueAuthentication,
            onPressed: selectedPackage != null ? () => _nextStep(l10n) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityStep(AppLocalizations l10n) {
    return SingleChildScrollView(
      key: const ValueKey(1),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 24, vertical: 10),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.personalIdentity,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.identityStepDesc,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary.withAlpha(200),
              ),
            ),
            const SizedBox(height: 32),
            EliteTextField(
              controller: fullNameCtrl,
              label: l10n.fullLegalName,
              icon: Icons.person_outline_rounded,
            ),
            EliteTextField(
              controller: phoneCtrl,
              label: l10n.primaryContactNumber,
              icon: Icons.phone_outlined,
              keyboard: TextInputType.phone,
            ),
            EliteTextField(
              controller: addressCtrl,
              label: l10n.residencyAddress,
              icon: Icons.location_on_outlined,
            ),
            _dropdown(l10n.selectGender, gender, {
              'male': l10n.male,
              'female': l10n.female,
            }, (v) => setState(() => gender = v!)),
            const SizedBox(height: 24),
            EliteButton(
              label: l10n.proceedToVehicle,
              onPressed: () => _nextStep(l10n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleStep(AppLocalizations l10n) {
    final subscriptionState = ref.watch(subscriptionProvider);

    return SingleChildScrollView(
      key: const ValueKey(2),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 24, vertical: 10),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.vehicleSpecification,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.vehicleStepDesc,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary.withAlpha(200),
              ),
            ),
            const SizedBox(height: 32),
            EliteTextField(
              controller: carBrandCtrl,
              label: l10n.manufacturerBrand,
              icon: Icons.directions_car_filled_outlined,
            ),
            EliteTextField(
              controller: carModelCtrl,
              label: l10n.vehicleModel,
              icon: Icons.model_training_outlined,
            ),
            Row(
              children: [
                Expanded(
                  child: EliteTextField(
                    controller: carYearCtrl,
                    label: l10n.manufactureYear,
                    icon: Icons.calendar_today_outlined,
                    keyboard: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: EliteTextField(
                    controller: carPlateCtrl,
                    label: l10n.plateIdentifier,
                    icon: Icons.badge_outlined,
                  ),
                ),
              ],
            ),
            EliteTextField(
              controller: carChassisCtrl,
              label: l10n.chassisVin,
              icon: Icons.format_list_numbered_rtl_rounded,
            ),
            _dropdown(l10n.preferredPayment, paymentMethod, {
              'cash': l10n.cash,
              'online': l10n.online,
            }, (v) => setState(() => paymentMethod = v!)),
            const SizedBox(height: 24),
            EliteButton(
              label: l10n.confirmMembership,
              isLoading: subscriptionState.isLoading,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ref.read(subscriptionProvider.notifier).submit({
                    'full_name': fullNameCtrl.text,
                    'phone': phoneCtrl.text,
                    'address': addressCtrl.text,
                    'car_brand': carBrandCtrl.text,
                    'car_model': carModelCtrl.text,
                    'car_made_year': carYearCtrl.text,
                    'car_chassis': carChassisCtrl.text,
                    'car_plate': carPlateCtrl.text,
                    'gender': gender,
                    'payment_method': paymentMethod,
                    'package_id': selectedPackage!.id.toString(),
                    'birthday': '1995-10-10',
                  });
                }
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageCard(SubscriptionPackage pkg) {
    final isSelected = selectedPackage?.id == pkg.id;

    return GestureDetector(
      onTap: () => setState(() => selectedPackage = pkg),
      child: AnimatedContainer(
        duration: 300.ms,
        margin: const EdgeInsetsDirectional.only(bottom: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isSelected ? 10 : 5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pkg.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${pkg.price.toInt()} SAR',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...pkg.features.map((feature) => Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.success),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: TextStyle(
                            fontSize: 13, 
                            color: AppColors.textSecondary.withAlpha(200),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _dropdown(String label, String value, Map<String, String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 20),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        items: items.entries
            .map((e) => DropdownMenuItem(
                  value: e.key,
                  child: Text(e.value),
                ))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 13, 
            color: AppColors.textSecondary.withAlpha(180),
            letterSpacing: 0.2,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }
}
