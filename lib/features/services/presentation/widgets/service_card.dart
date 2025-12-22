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
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 140,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.divider.withAlpha(80),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: service.brandColor.withAlpha(12),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: service.image != null && service.image!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: service.image!,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Icon(
                          _getIconData(service.icon),
                          color: service.brandColor,
                          size: 18,
                        ),
                      )
                    : Icon(
                        _getIconData(service.icon),
                        color: service.brandColor,
                        size: 18,
                      ),
              ),
            ),
            const Spacer(),
            Text(
              service.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 28, // Fix height for 2 lines of 10pt text to prevent overflows
              child: Text(
                service.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary.withAlpha(160),
                  height: 1.3,
                  letterSpacing: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).moveY(begin: 4, end: 0, curve: Curves.easeOutCubic);
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
