import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_pink_club/core/theme/app_colors.dart';
import 'package:the_pink_club/features/about/presentation/providers/about_cubit.dart';
import 'package:the_pink_club/features/about/presentation/providers/about_state.dart';
import 'package:the_pink_club/features/about/presentation/widgets/section_card.dart';
import 'package:the_pink_club/l10n/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: BlocBuilder<AboutCubit, AboutState>(
        builder: (context, state) {
          if (state is AboutLoading) {
            return const Center(child: CircularProgressIndicator(strokeWidth: 2));
          } else if (state is AboutError) {
            return Center(child: Text(state.message));
          } else if (state is AboutLoaded) {
            final about = state.about;
            return ListView(
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
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
