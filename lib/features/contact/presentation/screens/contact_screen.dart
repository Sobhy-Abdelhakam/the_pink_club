import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_pink_club/features/contact/presentation/providers/contact_provider.dart';

class ContactScreen extends ConsumerStatefulWidget {
  const ContactScreen({super.key});

  @override
  ConsumerState<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends ConsumerState<ContactScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final messageCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final contactState = ref.watch(contactProvider);

    ref.listen(contactProvider, (prev, next) {
      next.whenOrNull(
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Message sent successfully')),
          );
          _formKey.currentState?.reset();
        },
        error: (e, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _input(nameCtrl, 'Name'),
            _input(emailCtrl, 'Email',
                keyboard: TextInputType.emailAddress),
            _input(phoneCtrl, 'Phone',
                keyboard: TextInputType.phone),
            _input(messageCtrl, 'Message', maxLines: 4),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: contactState.isLoading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        ref.read(contactProvider.notifier).send({
                          'name': nameCtrl.text,
                          'email': emailCtrl.text,
                          'phone': phoneCtrl.text,
                          'message': messageCtrl.text,
                        });
                      }
                    },
              child: contactState.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Send Message'),
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
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        maxLines: maxLines,
        validator: (v) =>
            v == null || v.isEmpty ? 'Required field' : null,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
