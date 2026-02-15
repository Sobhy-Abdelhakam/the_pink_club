import 'package:flutter/material.dart';
import 'package:the_pink_club/core/theme/app_colors.dart';
import 'package:the_pink_club/features/services/presentation/screens/home_screen.dart';
import 'package:the_pink_club/features/providers/presentation/screens/providers_screen.dart';
import 'package:the_pink_club/features/subscription/presentation/screen/subscription_screen.dart';
import 'package:the_pink_club/features/contact/presentation/screens/contact_screen.dart';
import 'package:the_pink_club/features/about/presentation/screens/about_screen.dart';
import 'package:the_pink_club/l10n/app_localizations.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<bool> _visited;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _visited = List.generate(5, (index) => index == 0);
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
      _visited[index] = true;
    });
  }

  Widget _buildLazyScreen(int index) {
    if (!_visited[index]) {
      return const SizedBox.shrink();
    }

    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const ProvidersScreen();
      case 2:
        return const SubscriptionScreen();
      case 3:
        return const ContactScreen();
      case 4:
        return const AboutScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: List.generate(5, (index) => _buildLazyScreen(index)),
      ),
      bottomNavigationBar: Container(
        height: 88,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppColors.divider.withAlpha(150), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary.withAlpha(120),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
            height: 1.5,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
            height: 1.5,
          ),
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.grid_view_rounded, size: 20),
              label: l10n.navServices,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.business_center_rounded, size: 20),
              label: l10n.navPartners,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.star_rounded, size: 20),
              label: l10n.navMembership,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.email_rounded, size: 20),
              label: l10n.navContact,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.info_rounded, size: 20),
              label: l10n.navIdentity,
            ),
          ],
        ),
      ),
    );
  }
}
