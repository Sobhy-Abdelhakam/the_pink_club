import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_pink_club/features/about/presentation/providers/about_provider.dart';
import 'package:the_pink_club/features/about/presentation/widgets/section_card.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutAsync = ref.watch(aboutProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: aboutAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (about) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SectionCard(
              icon: Icons.visibility,
              title: 'Our Vision',
              content: about.vision,
              theme: theme,
            ),
            const SizedBox(height: 20),
            SectionCard(
              icon: Icons.flag,
              title: 'Our Mission',
              content: about.mission,
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }
}
