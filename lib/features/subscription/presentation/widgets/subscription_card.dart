import 'package:flutter/material.dart';
import 'package:the_pink_club/features/subscription/data/models/subscription_package.dart';
import 'package:the_pink_club/l10n/app_localizations.dart';

class SubscriptionCard extends StatefulWidget {
  final SubscriptionPackage package;

  const SubscriptionCard({super.key, required this.package});

  @override
  State<SubscriptionCard> createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.package.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${widget.package.price.toStringAsFixed(0)} EGP',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Features
            AnimatedCrossFade(
              firstChild: _buildFeatures(limit: 3),
              secondChild: _buildFeatures(),
              crossFadeState: expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),

            const SizedBox(height: 8),

            // Expand Button
            TextButton(
              onPressed: () => setState(() => expanded = !expanded),
              child: Text(expanded ? l10n.showLess : l10n.showMore),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatures({int? limit}) {
    final features = limit == null
        ? widget.package.features
        : widget.package.features.take(limit).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features.map(_FeatureItem.new).toList(),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String text;

  const _FeatureItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text.replaceAll('\r\n', '\n'),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
