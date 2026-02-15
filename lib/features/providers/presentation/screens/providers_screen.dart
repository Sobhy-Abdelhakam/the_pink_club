import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_pink_club/core/theme/app_colors.dart';
import 'package:the_pink_club/features/providers/presentation/providers/providers_cubit.dart';
import 'package:the_pink_club/features/providers/presentation/providers/providers_state.dart';
import 'package:the_pink_club/l10n/app_localizations.dart';

import 'provider_details_screen.dart';

class ProvidersScreen extends StatelessWidget {
  const ProvidersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.bespokePartners),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          letterSpacing: 0.5,
        ),
      ),
      body: BlocBuilder<ProvidersCubit, ProvidersState>(
        builder: (context, state) {
          if (state is ProvidersLoading) {
            return const Center(child: CircularProgressIndicator(strokeWidth: 2));
          } else if (state is ProvidersError) {
            return Center(child: Text(state.message));
          } else if (state is ProvidersLoaded) {
            final providers = state.ads;
            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 24, vertical: 20),
              itemCount: providers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (_, index) {
                final provider = providers[index];

                final name = locale == 'ar' ? provider.name : provider.nameEn;
                final desc = locale == 'ar'
                    ? provider.shortDesc
                    : provider.shortDescEn;

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProviderDetailsScreen(provider: provider),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.divider, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(5),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadiusDirectional.only(
                              topStart: Radius.circular(20),
                              bottomStart: Radius.circular(20),
                            ),
                            child: SizedBox(
                              width: 110,
                              height: 110,
                              child: CachedNetworkImage(
                                imageUrl: provider.image,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: AppColors.divider,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: AppColors.divider,
                                  child: const Icon(
                                    Icons.business_rounded,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: AppColors.textPrimary,
                                      letterSpacing: -0.2,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    desc,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                      height: 1.5,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: (index * 50).ms).moveY(begin: 10, end: 0);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
