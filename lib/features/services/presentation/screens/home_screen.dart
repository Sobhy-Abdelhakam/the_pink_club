import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_pink_club/core/network/api_actions.dart';
import 'package:the_pink_club/core/theme/app_colors.dart';
import 'package:the_pink_club/features/providers/presentation/providers/providers_provider.dart';
import 'package:the_pink_club/features/providers/presentation/widgets/ads_carousel_widget.dart';
import 'package:the_pink_club/features/services/presentation/providers/services_provider.dart';
import 'package:the_pink_club/features/services/presentation/widgets/service_card.dart';
import 'package:the_pink_club/core/widgets/language_switcher.dart';
import 'package:the_pink_club/l10n/app_localizations.dart';

/// Provider to track which sections should load their data
final sectionLoadVisibilityProvider = StateProvider<Set<String>>((ref) => {});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Start scheduling loads after UI is settled (500ms delay)
    // This prevents blocking the first frame render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduleLoads();
    });
  }

  void _scheduleLoads() {
    final sections = [
      ApiActions.car, // Premium Assistance
      ApiActions.advisory,
      ApiActions.medicalServices,
      ApiActions.medical,
      ApiActions.concierge,
      ApiActions.automotive,
      ApiActions.license,
      ApiActions.secondMedical,
      ApiActions.more,
    ];

    // Aggressive staggering: 1200ms initial delay + 400ms between sections
    // This ensures minimal concurrent requests and zero main thread blocking
    for (int i = 0; i < sections.length; i++) {
      Future.delayed(Duration(milliseconds: 1200 + (i * 400)), () {
        if (mounted) {
          // Use microtask to defer state update to next event loop cycle
          Future.microtask(() {
            if (mounted) {
              ref.read(sectionLoadVisibilityProvider.notifier).state = {
                ...ref.read(sectionLoadVisibilityProvider),
                sections[i],
              };
            }
          });
        }
      });
    }
  }

  void _onScroll() {
    // Trigger loading of sections as user scrolls near them
    final offset = _scrollController.offset;
    final sectionHeight = 250.0;

    if (offset > sectionHeight * 2) {
      _loadSection(ApiActions.advisory);
    }
    if (offset > sectionHeight * 4) {
      _loadSection(ApiActions.medicalServices);
      _loadSection(ApiActions.medical);
    }
  }

  void _loadSection(String action) {
    final loadedSections = ref.read(sectionLoadVisibilityProvider);
    if (!loadedSections.contains(action)) {
      ref.read(sectionLoadVisibilityProvider.notifier).state = {
        ...loadedSections,
        action,
      };
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),

          // Ads Section (Lazy loaded)
          _buildAdsSection(ref),

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

  Widget _buildAdsSection(WidgetRef ref) {
    final loadedSections = ref.watch(sectionLoadVisibilityProvider);

    // Only load ads when first section is marked as ready
    if (!loadedSections.contains(ApiActions.car)) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary.withAlpha(100),
            ),
          ),
        ),
      );
    }

    final adsAsync = ref.watch(providersAdsProvider);
    return SliverToBoxAdapter(
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
      // actions: [
      //   Padding(
      //     padding: const EdgeInsetsDirectional.only(end: 12),
      //     child: IconButton(
      //       icon: const Icon(Icons.notifications_outlined, size: 24),
      //       onPressed: () {},
      //     ),
      //   ),
      // ],
    );
  }

  Widget _buildServiceSection(WidgetRef ref, String title, String action) {
    final loadedSections = ref.watch(sectionLoadVisibilityProvider);
    final shouldLoad = loadedSections.contains(action);

    // Don't load data unless the section is marked as visible
    if (!shouldLoad) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

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
