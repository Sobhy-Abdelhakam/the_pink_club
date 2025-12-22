import 'package:flutter/material.dart';
import 'package:the_pink_club/core/theme/app_colors.dart';
import 'package:the_pink_club/features/services/presentation/screens/home_screen.dart';
import 'package:the_pink_club/features/providers/presentation/screens/providers_screen.dart';
import 'package:the_pink_club/features/subscription/presentation/screen/subscription_screen.dart';
import 'package:the_pink_club/features/contact/presentation/screens/contact_screen.dart';
import 'package:the_pink_club/features/about/presentation/screens/about_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ProvidersScreen(),
    const SubscriptionScreen(),
    const ContactScreen(),
    const AboutScreen(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded, size: 20),
              label: 'SERVICES',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business_center_rounded, size: 20),
              label: 'PARTNERS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star_rounded, size: 20),
              label: 'MEMBERSHIP',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.support_agent_rounded, size: 20),
              label: 'CONCIERGE',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info_rounded, size: 20),
              label: 'IDENTITY',
            ),
          ],
        ),
      ),
    );
  }
}
