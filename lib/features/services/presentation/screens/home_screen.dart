import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_pink_club/core/network/api_actions.dart';
import 'package:the_pink_club/core/theme/app_colors.dart';
import 'package:the_pink_club/features/providers/presentation/providers/providers_provider.dart';
import 'package:the_pink_club/features/providers/presentation/widgets/ads_carousel_widget.dart';
import 'package:the_pink_club/features/services/presentation/providers/services_provider.dart';
import 'package:the_pink_club/features/services/presentation/widgets/service_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adsAsync = ref.watch(providersAdsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),

          // Compact Welcome Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Premium Member',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'The Pink Club',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.6,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.divider,
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.textPrimary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSearchField(),
                ],
              ),
            ),
          ),

          // Ads Section
          SliverToBoxAdapter(
            child: adsAsync.when(
              loading: () => const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              error: (context, error) => const SizedBox.shrink(),
              data: (ads) => Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: AdsCarouselWidget(ads: ads),
              ),
            ),
          ),

          // Sections
          _buildServiceSection(ref, 'Premium Assistance', ApiActions.car),
          _buildServiceSection(ref, 'Strategic Advisory', ApiActions.advisory),
          _buildServiceSection(
            ref,
            'Medical Network',
            ApiActions.medicalServices,
          ),
          _buildServiceSection(ref, 'Health Advisory', ApiActions.medical),
          _buildServiceSection(ref, 'Elite Concierge', ApiActions.concierge),
          _buildServiceSection(ref, 'Vehicle Supplies', ApiActions.automotive),
          _buildServiceSection(ref, 'License Services', ApiActions.license),
          _buildServiceSection(ref, 'Second Opinion', ApiActions.secondMedical),
          _buildServiceSection(ref, 'Explore More', ApiActions.more),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'THE PINK CLUB',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          letterSpacing: 2.5,
          color: AppColors.textPrimary.withAlpha(150),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: IconButton(
            icon: const Icon(Icons.notifications_none_rounded, size: 22),
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
      error: (context, error) => const SliverToBoxAdapter(child: SizedBox.shrink()),
      data: (services) {
        if (services.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        return SliverMainAxisGroup(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 20, 28, 12),
                child: Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary.withAlpha(180),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 160, // Elite breathing room
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: services.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 14),
                  itemBuilder: (context, index) => ServiceCard(service: services[index]),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 0.8),
      ),
      child: const Row(
        children: [
          Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search services...',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
