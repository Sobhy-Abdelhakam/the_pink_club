import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_pink_club/features/subscription/presentation/providers/subscription_provider.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() =>
      _SubscriptionScreenState();
}

class _SubscriptionScreenState
    extends ConsumerState<SubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();

  final fullNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final carBrandCtrl = TextEditingController();
  final carModelCtrl = TextEditingController();
  final carYearCtrl = TextEditingController();
  final carChassisCtrl = TextEditingController();
  final carPlateCtrl = TextEditingController();

  String gender = 'male';
  String paymentMethod = 'cash';

  @override
  Widget build(BuildContext context) {
    final subscriptionState = ref.watch(subscriptionProvider);

    ref.listen(subscriptionProvider, (prev, next) {
      next.whenOrNull(
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Subscription submitted')),
          );
        },
        error: (e, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Subscribe')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _input(fullNameCtrl, 'Full Name'),
            _input(phoneCtrl, 'Phone', keyboard: TextInputType.phone),
            _input(addressCtrl, 'Address'),
            _input(carBrandCtrl, 'Car Brand'),
            _input(carModelCtrl, 'Car Model'),
            _input(carYearCtrl, 'Car Made Year',
                keyboard: TextInputType.number),
            _input(carChassisCtrl, 'Car Chassis'),
            _input(carPlateCtrl, 'Car Plate'),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: gender,
              items: const [
                DropdownMenuItem(value: 'male', child: Text('Male')),
                DropdownMenuItem(value: 'female', child: Text('Female')),
              ],
              onChanged: (v) => gender = v!,
              decoration: const InputDecoration(labelText: 'Gender'),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: paymentMethod,
              items: const [
                DropdownMenuItem(value: 'cash', child: Text('Cash')),
                DropdownMenuItem(value: 'online', child: Text('Online')),
              ],
              onChanged: (v) => paymentMethod = v!,
              decoration:
                  const InputDecoration(labelText: 'Payment Method'),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: subscriptionState.isLoading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        ref
                            .read(subscriptionProvider.notifier)
                            .submit({
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
                          'package_id': '1',
                          'birthday': '1995-01-01',
                        });
                      }
                    },
              child: subscriptionState.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Submit Subscription'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(
    TextEditingController controller,
    String label, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: (v) =>
            v == null || v.isEmpty ? 'Required field' : null,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
