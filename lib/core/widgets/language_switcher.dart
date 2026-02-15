import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_pink_club/core/providers/locale_cubit.dart';
import 'package:the_pink_club/core/theme/app_colors.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, currentLocale) {
        final isArabic = currentLocale.languageCode == 'ar';

        return GestureDetector(
          onTap: () {
            context.read<LocaleCubit>().setLocale(
                  isArabic ? const Locale('en') : const Locale('ar'),
                );
          },
          child: Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(isArabic ? 20 : 10),
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
      },
    );
  }
}
