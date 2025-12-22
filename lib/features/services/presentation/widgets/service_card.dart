import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:the_pink_club/features/services/presentation/screens/service_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/service_model.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback? onTap;

  const ServiceCard({
    super.key,
    required this.service,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ServiceDetailsScreen(service: service),
          ),
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 154,
        padding: const EdgeInsetsDirectional.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.divider.withAlpha(100),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: service.brandColor.withAlpha(18),
                shape: BoxShape.circle,
                border: Border.all(
                  color: service.brandColor.withAlpha(30),
                  width: 1,
                ),
              ),
              child: Center(
                child: ClipOval(
                  child: service.image != null && service.image!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: service.image!,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Icon(
                            _getIconData(service.icon),
                            color: service.brandColor,
                            size: 20,
                          ),
                        )
                      : Icon(
                          _getIconData(service.icon),
                          color: service.brandColor,
                          size: 20,
                        ),
                ),
              ),
            ),
            const Spacer(),
            Text(
              service.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 32,
              child: Text(
                service.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      height: 1.4,
                      color: AppColors.textSecondary.withAlpha(180),
                    ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, curve: Curves.easeOut).moveY(begin: 8, end: 0, curve: Curves.easeOutCubic);
  }

  IconData _getIconData(String iconName) {
    final name = iconName.toLowerCase();
    if (name.contains('handshake')) return Icons.handshake_rounded;
    if (name.contains('car') || name.contains('automotive')) return Icons.directions_car_rounded;
    if (name.contains('heart') || name.contains('medical')) return Icons.medical_services_rounded;
    if (name.contains('gavel') || name.contains('advisory')) return Icons.gavel_rounded;
    if (name.contains('concierge') || name.contains('bell')) return Icons.support_agent_rounded;
    if (name.contains('hotel')) return Icons.hotel_rounded;
    if (name.contains('opinion')) return Icons.find_in_page_rounded;
    if (name.contains('license')) return Icons.badge_rounded;
    if (name.contains('more')) return Icons.grid_view_rounded;
    
    return Icons.auto_awesome_rounded;
  }
}
