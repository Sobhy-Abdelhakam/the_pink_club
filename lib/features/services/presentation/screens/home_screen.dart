import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_pink_club/core/network/api_actions.dart';
import 'package:the_pink_club/core/theme/app_colors.dart';
import 'package:the_pink_club/features/providers/presentation/providers/providers_provider.dart';
import 'package:the_pink_club/features/providers/presentation/widgets/ads_carousel_widget.dart';
import 'package:the_pink_club/features/services/presentation/providers/services_provider.dart';
import 'package:the_pink_club/features/services/presentation/widgets/service_card.dart';
import 'package:the_pink_club/core/widgets/language_switcher.dart';
import 'package:the_pink_club/l10n/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adsAsync = ref.watch(providersAdsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),

          // Ads Section
          SliverToBoxAdapter(
            child: adsAsync.when(
              loading: () => const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              error: (context, error) => const SizedBox.shrink(),
              data: (ads) => Padding(
                padding: const EdgeInsetsDirectional.only(top: 12, bottom: 28),
                child: AdsCarouselWidget(ads: ads),
              ),
            ),
          ),

          // Sections
          _buildServiceSection(ref, l10n.premiumAssistance, ApiActions.car),
          _buildServiceSection(
            ref,
            l10n.strategicAdvisory,
            ApiActions.advisory,
          ),
          _buildServiceSection(
            ref,
            l10n.medicalNetwork,
            ApiActions.medicalServices,
          ),
          _buildServiceSection(ref, l10n.healthAdvisory, ApiActions.medical),
          _buildServiceSection(ref, l10n.eliteConcierge, ApiActions.concierge),
          _buildServiceSection(
            ref,
            l10n.vehicleSupplies,
            ApiActions.automotive,
          ),
          _buildServiceSection(ref, l10n.licenseServices, ApiActions.license),
          _buildServiceSection(
            ref,
            l10n.secondOpinion,
            ApiActions.secondMedical,
          ),
          _buildServiceSection(ref, l10n.exploreMore, ApiActions.more),

          const SliverToBoxAdapter(child: SizedBox(height: 60)),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: false,
      backgroundColor: AppColors.background.withAlpha(240),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leadingWidth: 100,
      leading: const Center(child: LanguageSwitcher()),
      title: Text(
        AppLocalizations.of(context)!.appTitle.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 2.0,
          color: AppColors.textPrimary.withAlpha(180),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 12),
          child: IconButton(
            icon: const Icon(Icons.notifications_outlined, size: 24),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildServiceSection(WidgetRef ref, String title, String action) {
    final servicesAsync = ref.watch(servicesProvider(action));

    return servicesAsync.when(
      loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
      error: (context, error) =>
          const SliverToBoxAdapter(child: SizedBox.shrink()),
      data: (services) {
        if (services.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        return SliverMainAxisGroup(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(28, 32, 28, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {},
                      child: Builder(
                        builder: (context) => Text(
                          AppLocalizations.of(context)!.viewAll,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary.withAlpha(200),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 172, // Calibrated height
                child: ListView.separated(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 28,
                  ),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: services.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 16),
                  itemBuilder: (context, index) =>
                      ServiceCard(service: services[index]),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
