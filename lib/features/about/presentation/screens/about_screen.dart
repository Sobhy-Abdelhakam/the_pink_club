import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_pink_club/core/theme/app_colors.dart';
import 'package:the_pink_club/features/about/presentation/providers/about_provider.dart';
import 'package:the_pink_club/features/about/presentation/widgets/section_card.dart';
import 'package:the_pink_club/l10n/app_localizations.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutAsync = ref.watch(aboutProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.ourIdentity),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          letterSpacing: 0.5,
        ),
      ),
      body: aboutAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (about) => ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 24, vertical: 24),
          children: [
            Text(
              l10n.appTitle,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                letterSpacing: -1.0,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.aboutTagline,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary.withAlpha(200),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 48),
            SectionCard(
              icon: Icons.visibility_outlined,
              title: l10n.ourVision,
              content: about.vision,
            ).animate().fadeIn(duration: 500.ms).moveX(begin: -20, end: 0),
            const SizedBox(height: 24),
            SectionCard(
              icon: Icons.flag_outlined,
              title: l10n.ourMission,
              content: about.mission,
            ).animate().fadeIn(duration: 500.ms, delay: 200.ms).moveX(begin: 20, end: 0),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
