import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/model/provider_ad_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../screens/provider_details_screen.dart';

class AdsCarouselWidget extends StatefulWidget {
  final List<ProviderAdModel> ads;

  const AdsCarouselWidget({
    super.key,
    required this.ads,
  });

  @override
  State<AdsCarouselWidget> createState() => _AdsCarouselWidgetState();
}

class _AdsCarouselWidgetState extends State<AdsCarouselWidget> {
  final CarouselSliderController _controller = CarouselSliderController();
  final ValueNotifier<int> _activeIndexNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    _activeIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ads.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: widget.ads.length,
          itemBuilder: (context, index, realIndex) {
            final ad = widget.ads[index];

            return _AdItem(
              key: ValueKey(ad.image), // Important for stability
              ad: ad,
            );
          },
          options: CarouselOptions(
            height: 240,
            viewportFraction: 1,
            enlargeCenterPage: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, reason) {
              _activeIndexNotifier.value = index;
            },
          ),
        ),

        const SizedBox(height: 4),

        /// Only indicator rebuilds
        ValueListenableBuilder<int>(
          valueListenable: _activeIndexNotifier,
          builder: (context, activeIndex, _) {
            return AnimatedSmoothIndicator(
              activeIndex: activeIndex,
              count: widget.ads.length,
              effect: const ExpandingDotsEffect(
                dotHeight: 5,
                dotWidth: 5,
                expansionFactor: 4,
                spacing: 8,
                activeDotColor: AppColors.primary,
                dotColor: AppColors.divider,
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Extracted into separate widget to prevent unnecessary rebuilds
class _AdItem extends StatelessWidget {
  final ProviderAdModel ad;

  const _AdItem({
    super.key,
    required this.ad,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProviderDetailsScreen(provider: ad),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              /// Cached Image
              CachedNetworkImage(
                imageUrl: ad.image,
                fit: BoxFit.cover,
                memCacheWidth: 1200, // Optional optimization
                placeholder: (context, url) => Container(
                  color: AppColors.surfaceVariant,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.surfaceVariant,
                  child: const Icon(
                    Icons.broken_image_rounded,
                    size: 32,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              /// Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withAlpha(200),
                      Colors.black.withAlpha(80),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              /// Text
              Positioned(
                bottom: 24,
                left: 24,
                right: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ad.name.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ad.shortDesc,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
