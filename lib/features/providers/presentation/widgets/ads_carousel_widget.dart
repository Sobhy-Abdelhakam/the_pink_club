import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/model/provider_ad_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../screens/provider_details_screen.dart';

class AdsCarouselWidget extends StatefulWidget {
  final List<ProviderAdModel> ads;

  const AdsCarouselWidget({super.key, required this.ads});

  @override
  State<AdsCarouselWidget> createState() => _AdsCarouselWidgetState();
}

class _AdsCarouselWidgetState extends State<AdsCarouselWidget> {
  int _activeIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

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
            debugPrint('Ads Carousel Image URL: ${ad.image}');
            return _buildAdItem(ad);
          },
          options: CarouselOptions(
            height: 240,
            viewportFraction: 1,
            enlargeCenterPage: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, reason) {
              setState(() {
                _activeIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 4),
        AnimatedIndicator(activeIndex: _activeIndex, count: widget.ads.length),
      ],
    );
  }

  Widget _buildAdItem(ProviderAdModel ad) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProviderDetailsScreen(provider: ad),
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
            children: [
              CachedNetworkImage(
                imageUrl: ad.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) => Container(
                  color: AppColors.surfaceVariant,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.surfaceVariant,
                  child: const Icon(Icons.broken_image_rounded, size: 32, color: AppColors.textSecondary),
                ),
              ),
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

class AnimatedIndicator extends StatelessWidget {
  final int activeIndex;
  final int count;

  const AnimatedIndicator({
    super.key,
    required this.activeIndex,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: count,
      effect: const ExpandingDotsEffect(
        dotHeight: 5,
        dotWidth: 5,
        expansionFactor: 4,
        spacing: 8,
        activeDotColor: AppColors.primary,
        dotColor: AppColors.divider,
      ),
    );
  }
}
