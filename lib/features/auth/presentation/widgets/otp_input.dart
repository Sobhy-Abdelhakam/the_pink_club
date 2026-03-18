import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';

class OtpInput extends StatefulWidget {
  final int length;
  final ValueChanged<String> onChanged;
  final bool enabled;

  const OtpInput({
    super.key,
    this.length = 6,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.enabled) _focusNodes.first.requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String _otpFromControllers() {
    return _controllers.map((c) => c.text).join();
  }

  void _moveFocus(int index) {
    if (index < 0 || index >= widget.length) return;
    _focusNodes[index].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 44,
          child: TextField(
            enabled: widget.enabled,
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
            maxLength: widget.length,
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.divider, width: 0.8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.divider, width: 0.8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.error, width: 1),
              ),
            ),
            onChanged: (value) {
              if (_isSyncing) return;
              final digits = value.replaceAll(RegExp(r'\\D'), '');

              if (digits.isEmpty) {
                widget.onChanged(_otpFromControllers());
                // If user cleared this box, jump back one box (nice UX).
                if (index > 0) {
                  _moveFocus(index - 1);
                }
                return;
              }

              if (digits.length == 1) {
                widget.onChanged(_otpFromControllers());

                if (index + 1 < widget.length) {
                  _moveFocus(index + 1);
                } else {
                  _focusNodes[index].unfocus();
                }
                return;
              }

              // Handle paste/autofill where multiple digits arrive at once.
              int cursor = index;
              _isSyncing = true;
              for (int i = 0;
                  i < digits.length && cursor < widget.length;
                  i++, cursor++) {
                _controllers[cursor].text = digits[i];
              }

              // Clear remaining cells so the OTP is consistent.
              for (int i = cursor; i < widget.length; i++) {
                _controllers[i].text = '';
              }
              final otp = _otpFromControllers();
              _isSyncing = false;

              widget.onChanged(otp);
              final next = index + digits.length;
              if (next < widget.length) {
                _moveFocus(next);
              } else {
                _focusNodes.last.unfocus();
              }
            },
          ),
        );
      }),
    );
  }
}

