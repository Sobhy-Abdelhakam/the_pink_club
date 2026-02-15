import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_pink_club/core/network/api_actions.dart';
import 'package:the_pink_club/core/theme/app_colors.dart';
import 'package:the_pink_club/features/providers/presentation/providers/providers_cubit.dart';
import 'package:the_pink_club/features/providers/presentation/providers/providers_state.dart';
import 'package:the_pink_club/features/providers/presentation/widgets/ads_carousel_widget.dart';
import 'package:the_pink_club/features/services/presentation/providers/services_cubit.dart';
import 'package:the_pink_club/features/services/presentation/providers/services_state.dart';
import 'package:the_pink_club/features/services/presentation/widgets/service_card.dart';
import 'package:the_pink_club/core/widgets/language_switcher.dart';
import 'package:the_pink_club/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;

  static const List<String> _allSections = [
    ApiActions.car,
    ApiActions.advisory,
    ApiActions.medicalServices,
    ApiActions.medical,
    ApiActions.concierge,
    ApiActions.automotive,
    ApiActions.license,
    ApiActions.secondMedical,
    ApiActions.more,
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Fetch all data immediately on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ServicesCubit>().fetchMultipleSections(_allSections);
        context.read<ProvidersCubit>().fetchAds();
      }
    });
  }

  @override
  void dispose() {
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
          _buildAdsSection(),
          _buildServiceSection(l10n.premiumAssistance, ApiActions.car),
          _buildServiceSection(l10n.strategicAdvisory, ApiActions.advisory),
          _buildServiceSection(l10n.medicalNetwork, ApiActions.medicalServices),
          _buildServiceSection(l10n.healthAdvisory, ApiActions.medical),
          _buildServiceSection(l10n.eliteConcierge, ApiActions.concierge),
          _buildServiceSection(l10n.vehicleSupplies, ApiActions.automotive),
          _buildServiceSection(l10n.licenseServices, ApiActions.license),
          _buildServiceSection(l10n.secondOpinion, ApiActions.secondMedical),
          _buildServiceSection(l10n.exploreMore, ApiActions.more),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildAdsSection() {
    return SliverToBoxAdapter(
      child: BlocBuilder<ProvidersCubit, ProvidersState>(
        builder: (context, state) {
          if (state is ProvidersLoading) {
            return const SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          } else if (state is ProvidersLoaded) {
            if (state.ads.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsetsDirectional.only(top: 12, bottom: 28),
              child: AdsCarouselWidget(ads: state.ads),
            );
          } else if (state is ProvidersError) {
            return SizedBox(
              height: 100,
              child: Center(
                child: Text(
                  'Unable to load ads',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      leadingWidth: 0,
      leading: const SizedBox.shrink(),
      title: Row(
        children: [_buildUserInfo(), const Spacer(), const LanguageSwitcher()],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.appTitle.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          "Welcome back, Queen",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceSection(String title, String action) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      builder: (context, state) {
        if (state is ServicesLoading) {
          // Show loading only for the first section
          if (action == ApiActions.car) {
            return const SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        } else if (state is ServicesLoaded) {
          final services = state.getServices(action);
          if (services.isEmpty) {
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          }

          return SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: services.first.brandColor.withAlpha(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      24,
                      0,
                      24,
                      20,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 20,
                          decoration: BoxDecoration(
                            color: services.first.brandColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.separated(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 24,
                      ),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: services.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) =>
                          ServiceCard(service: services[index]),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is ServicesError) {
          // Only show error for the first section to avoid cluttering UI
          if (action == ApiActions.car) {
            return SliverToBoxAdapter(
              child: Container(
                height: 100,
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.error.withAlpha(10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.error.withAlpha(50),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: AppColors.error),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Unable to load services',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.error,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Please check your connection',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<ServicesCubit>().fetchMultipleSections(_allSections);
                      },
                      icon: Icon(Icons.refresh, color: AppColors.error),
                    ),
                  ],
                ),
              ),
            );
          }
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
