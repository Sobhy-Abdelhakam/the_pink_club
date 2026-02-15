import 'package:flutter/material.dart';
import 'package:the_pink_club/features/services/presentation/screens/service_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/service_model.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback? onTap;

  const ServiceCard({super.key, required this.service, this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = service.brandColor;

    return RepaintBoundary(
      child: Container(
        width: 144,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(10),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withAlpha(4),
              blurRadius: 20,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap:
                onTap ??
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ServiceDetailsScreen(service: service),
                    ),
                  );
                },
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Image/Icon Section
                Expanded(
                  // flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: AppColors.glassGradient(color),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: service.image != null && service.image!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: service.image!,
                              width: double.infinity,
                              // height: 80,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    color.withAlpha(80),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                _getIconData(service.icon),
                                color: color,
                                size: 40,
                              ),
                            )
                          : Icon(
                              _getIconData(service.icon),
                              color: color,
                              size: 48,
                            ),
                    ),
                  ),
                ),
                // Content Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        service.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          height: 1.3,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary.withAlpha(160),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    final name = iconName.toLowerCase();
    if (name.contains('handshake')) return Icons.handshake_rounded;
    if (name.contains('car') || name.contains('automotive')) {
      return Icons.directions_car_rounded;
    }
    if (name.contains('heart') || name.contains('medical')) {
      return Icons.medical_services_rounded;
    }
    if (name.contains('heartbeat')) return Icons.monitor_heart_rounded;
    if (name.contains('hospital')) return Icons.local_hospital_rounded;
    if (name.contains('gavel') || name.contains('advisory')) {
      return Icons.gavel_rounded;
    }
    if (name.contains('concierge') || name.contains('bell')) {
      return Icons.support_agent_rounded;
    }
    if (name.contains('hotel')) return Icons.business_center_rounded;
    if (name.contains('opinion')) return Icons.find_in_page_rounded;
    if (name.contains('license') || name.contains('id-card')) {
      return Icons.badge_rounded;
    }
    if (name.contains('more')) return Icons.grid_view_rounded;

    return Icons.auto_awesome_rounded;
  }
}
