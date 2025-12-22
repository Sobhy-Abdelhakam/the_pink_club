import 'dart:ui';
import 'package:the_pink_club/core/theme/app_colors.dart';

class ServiceModel {
  final int id;
  final String title;
  final String description;
  final String icon;
  final String color;
  final String? image;
  final List<String> features;

  ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.image,
    required this.features,
  });

  Color get brandColor {
    try {
      final hexColor = color.replaceAll('#', '');
      return Color(int.parse('FF$hexColor', radix: 16));
    } catch (_) {
      return AppColors.primary;
    }
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    String? imagePath = json['image'];
    if (imagePath != null && imagePath.isNotEmpty && !imagePath.startsWith('http')) {
      final cleanPath = imagePath.startsWith('/') ? imagePath : '/$imagePath';
      if (cleanPath.startsWith('/admin/')) {
        imagePath = 'https://thepinkclub.net$cleanPath';
      } else {
        imagePath = 'https://thepinkclub.net/admin$cleanPath';
      }
    }

    return ServiceModel(
      id: int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      color: json['color'] ?? '#000000',
      image: imagePath,
      features: List<String>.from(json['features'] ?? []),
    );
  }
}
