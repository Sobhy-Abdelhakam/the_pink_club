import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_pink_club/core/di/service_locator.dart';
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
  final Set<String> _loadedSections = {};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduleLoads();
    });
  }

  void _scheduleLoads() {
    final sections = [
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

    for (int i = 0; i < sections.length; i++) {
      Future.delayed(Duration(milliseconds: 1200 + (i * 400)), () {
        if (mounted) {
          _loadSection(sections[i]);
        }
      });
    }

    context.read<ProvidersCubit>().fetchAds();
  }

  void _onScroll() {
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
    if (!_loadedSections.contains(action)) {
      setState(() {
        _loadedSections.add(action);
      });
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
          const SliverToBoxAdapter(child: SizedBox(height: 60)),
        ],
      ),
    );
  }

  Widget _buildAdsSection() {
    if (!_loadedSections.contains(ApiActions.car)) {
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

    return SliverToBoxAdapter(
      child: BlocBuilder<ProvidersCubit, ProvidersState>(
        builder: (context, state) {
          if (state is ProvidersLoading) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          } else if (state is ProvidersLoaded) {
            return Padding(
              padding: const EdgeInsetsDirectional.only(top: 12, bottom: 28),
              child: AdsCarouselWidget(ads: state.ads),
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
    if (!_loadedSections.contains(action)) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return BlocProvider(
      create: (context) => sl<ServicesCubit>()..fetchServices(action),
      child: BlocBuilder<ServicesCubit, ServicesState>(
        builder: (context, state) {
          if (state is ServicesLoading) {
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          } else if (state is ServicesLoaded) {
            final services = state.services;
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
          }
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        },
      ),
    );
  }
}
