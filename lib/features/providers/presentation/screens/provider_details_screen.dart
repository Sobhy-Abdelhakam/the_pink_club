import 'package:flutter/material.dart';
import 'package:the_pink_club/features/providers/data/model/provider_ad_model.dart';

class ProviderDetailsScreen extends StatelessWidget {
  final ProviderAdModel provider;

  const ProviderDetailsScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    final name =
        locale == 'ar' ? provider.name : provider.nameEn;
    final details =
        locale == 'ar' ? provider.details : provider.detailsEn;

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              provider.image,
              height: 220,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: Theme.of(context)
                .textTheme
                .headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(details),
        ],
      ),
    );
  }
}
