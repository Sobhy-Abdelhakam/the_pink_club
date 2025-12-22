import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_pink_club/core/theme/app_colors.dart';
import 'package:the_pink_club/core/widgets/elite_button.dart';
import 'package:the_pink_club/core/widgets/elite_text_field.dart';
import 'package:the_pink_club/features/subscription/data/models/subscription_package.dart';
import 'package:the_pink_club/features/subscription/presentation/providers/subscription_provider.dart';

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

  void _nextStep() {
    if (_currentStep == 0 && selectedPackage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a package first')),
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

    ref.listen(subscriptionProvider, (prev, next) {
      next.whenOrNull(
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Membership secured successfully'),
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
        title: const Text('Exclusive Membership'),
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
              child: _buildStepContent(packagesAsync),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
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
                      margin: const EdgeInsets.symmetric(horizontal: 10),
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

  Widget _buildStepContent(AsyncValue<List<SubscriptionPackage>> packagesAsync) {
    switch (_currentStep) {
      case 0:
        return _buildPackageStep(packagesAsync);
      case 1:
        return _buildIdentityStep();
      case 2:
        return _buildVehicleStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPackageStep(AsyncValue<List<SubscriptionPackage>> packagesAsync) {
    return SingleChildScrollView(
      key: const ValueKey(0),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Choose Your Privilege',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select the package that best fits your bespoke lifestyle.',
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
            error: (err, _) => Center(child: Text('Consultation Error: $err')),
            data: (packages) => Column(
              children: packages.map((pkg) => _buildPackageCard(pkg)).toList(),
            ),
          ),
          const SizedBox(height: 24),
          EliteButton(
            label: 'Continue Authentication',
            onPressed: selectedPackage != null ? _nextStep : null,
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityStep() {
    return SingleChildScrollView(
      key: const ValueKey(1),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Personal Identity',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete your authentication to proceed with the membership.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary.withAlpha(200),
              ),
            ),
            const SizedBox(height: 32),
            EliteTextField(
              controller: fullNameCtrl,
              label: 'Full Legal Name',
              icon: Icons.person_outline_rounded,
            ),
            EliteTextField(
              controller: phoneCtrl,
              label: 'Primary Contact Number',
              icon: Icons.phone_outlined,
              keyboard: TextInputType.phone,
            ),
            EliteTextField(
              controller: addressCtrl,
              label: 'Residency Address',
              icon: Icons.location_on_outlined,
            ),
            _dropdown('Select Gender', gender, ['male', 'female'], (v) => setState(() => gender = v!)),
            const SizedBox(height: 24),
            EliteButton(
              label: 'Proceed to Vehicle Details',
              onPressed: _nextStep,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleStep() {
    final subscriptionState = ref.watch(subscriptionProvider);

    return SingleChildScrollView(
      key: const ValueKey(2),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Vehicle Specification',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Register your primary vehicle for club eligibility.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary.withAlpha(200),
              ),
            ),
            const SizedBox(height: 32),
            EliteTextField(
              controller: carBrandCtrl,
              label: 'Manufacturer / Brand',
              icon: Icons.directions_car_filled_outlined,
            ),
            EliteTextField(
              controller: carModelCtrl,
              label: 'Vehicle Model',
              icon: Icons.model_training_outlined,
            ),
            Row(
              children: [
                Expanded(
                  child: EliteTextField(
                    controller: carYearCtrl,
                    label: 'Manufacture Year',
                    icon: Icons.calendar_today_outlined,
                    keyboard: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: EliteTextField(
                    controller: carPlateCtrl,
                    label: 'Plate Identifier',
                    icon: Icons.badge_outlined,
                  ),
                ),
              ],
            ),
            EliteTextField(
              controller: carChassisCtrl,
              label: 'Chassis VIN Number',
              icon: Icons.format_list_numbered_rtl_rounded,
            ),
            _dropdown('Preferred Payment', paymentMethod, ['cash', 'online'], (v) => setState(() => paymentMethod = v!)),
            const SizedBox(height: 24),
            EliteButton(
              label: 'Confirm Membership',
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
                    'birthday': '1995-10-10', // Standardized ISO-like placeholder
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
        margin: const EdgeInsets.only(bottom: 16),
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
                  padding: const EdgeInsets.only(bottom: 6),
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

  Widget _dropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        items: items
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.substring(0, 1).toUpperCase() + e.substring(1)),
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }
}
