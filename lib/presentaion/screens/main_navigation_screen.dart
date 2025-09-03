// presentation/screens/main_navigation_screen.dart

import 'package:flutter/material.dart';
import '../../../config/Colors/AppColors.dart';
import '../widgets/custom_navigation_bar.dart';
import '../widgets/navigation_popup.dart';
import 'home/home_screen.dart';
import 'buzz/buzz_screen.dart';
import 'hive/hive_screen.dart';
import 'brainy/brainy_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  bool _showPopup = false;

  final List<Widget> _screens = [
    const HomeScreen(),
    const BuzzScreen(),
    const HiveScreen(),
    const BrainyScreen(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _showPopup = false; // Close popup when switching tabs
    });
  }

  void _togglePopup() {
    setState(() {
      _showPopup = !_showPopup;
    });
  }

  void _closePopup() {
    setState(() {
      _showPopup = false;
    });
  }

  void _handleNavigation(String route) {
    _closePopup();
    // Handle navigation to other screens
    // Navigator.pushNamed(context, route);
    print('Navigating to: $route'); // For debugging
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content screens
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),

          // Full-screen popup overlay
          if (_showPopup)
            Positioned.fill(
              child: NavigationPopup(
                onClose: _closePopup,
                onNavigate: _handleNavigation,
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        onPopupTap: _togglePopup,
        showPopup: _showPopup,
      ),
    );
  }
}