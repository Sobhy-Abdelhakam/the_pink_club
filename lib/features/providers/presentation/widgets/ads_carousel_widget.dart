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
            height: 200,
            viewportFraction: 1,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, reason) {
              setState(() {
                _activeIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 10),
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
        margin: const EdgeInsetsDirectional.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.divider.withAlpha(100),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              // Background Image
              CachedNetworkImage(
                imageUrl: ad.image,
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) => Container(
                  color: AppColors.divider.withAlpha(50),
                  child: const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.divider.withAlpha(50),
                  child: const Icon(
                    Icons.business_rounded,
                    color: AppColors.textSecondary,
                    size: 28,
                  ),
                ),
              ),
              // Gradient Overlay (More subtle & sophisticated)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: AlignmentDirectional.bottomCenter,
                    end: AlignmentDirectional.topCenter,
                    stops: const [0.0, 0.45, 1.0],
                    colors: [
                      Colors.black.withAlpha(180),
                      Colors.black.withAlpha(40),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              // Text Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ad.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ad.shortDesc,
                      style: TextStyle(
                        color: Colors.white.withAlpha(220),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                      ),
                      maxLines: 1,
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
