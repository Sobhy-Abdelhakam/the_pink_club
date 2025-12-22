import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_pink_club/core/providers/locale_provider.dart';
import 'package:the_pink_club/core/theme/app_colors.dart';

class LanguageSwitcher extends ConsumerWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final isArabic = currentLocale.languageCode == 'ar';

    return GestureDetector(
      onTap: () {
        ref.read(localeProvider.notifier).setLocale(
              isArabic ? const Locale('en') : const Locale('ar'),
            );
      },
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.primary.withAlpha(currentLocale.languageCode == 'ar' ? 20 : 10),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: AppColors.primary.withAlpha(30),
            width: 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.language_rounded,
              size: 14,
              color: AppColors.primary.withAlpha(200),
            ),
            const SizedBox(width: 6),
            Text(
              isArabic ? 'English' : 'العربية',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
