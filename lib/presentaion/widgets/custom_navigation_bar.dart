// presentation/widgets/custom_navigation_bar.dart
import 'dart:ui';
import '../../config/Colors/AppColors.dart';
import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onPopupTap;
  final bool showPopup;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onPopupTap,
    required this.showPopup,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.17, // Extra height for floating button
      child: Stack(
        children: [
          // Main Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: size.height * 0.10,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavBarItem(
                    icon: 'assets/icons/home.png',
                    label: 'Home',
                    isSelected: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  _NavBarItem(
                    icon: 'assets/icons/buzz.png',
                    label: 'Buzz',
                    isSelected: currentIndex == 1,
                    onTap: () => onTap(1),
                  ),
                  _NavBarItem(
                    icon: 'assets/icons/hive.png',
                    label: 'Hive',
                    isSelected: currentIndex == 2,
                    onTap: () => onTap(2),
                  ),
                  _NavBarItem(
                    icon: 'assets/icons/brainy.png',
                    label: 'Brainy',
                    isSelected: currentIndex == 3,
                    onTap: () => onTap(3),
                  ),
                  _NavBarItem(
                    icon: 'assets/icons/profile.png',
                    label: 'Profile',
                    isSelected: currentIndex == 4,
                    onTap: () => onTap(4),
                  ),
                ],
              ),
            ),
          ),

          // Floating Circular Button
          Positioned(
            top: size.height * 0.02,
            left: MediaQuery.of(context).size.width / 2 - size.width * 0.08,
            child: GestureDetector(
              onTap: onPopupTap,
              child: Container(
                width: size.width * 0.16,
                height: size.width * 0.16,
                decoration: BoxDecoration(
                  color: showPopup ? AppColors.primaryPink : AppColors.primaryYellow,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (showPopup ? AppColors.primaryPink : AppColors.primaryYellow).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  showPopup ? Icons.close : Icons.apps,
                  color: showPopup ? Colors.white : Colors.black,
                  size: size.width * 0.07,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.02,
          vertical: size.height * 0.008,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with selection indicator
            Container(
              padding: EdgeInsets.all(size.width * 0.02),
              decoration: isSelected
                  ? BoxDecoration(
                color: AppColors.primaryYellow.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              )
                  : null,
              child: Image.asset(
                icon,
                width: size.width * 0.06,
                height: size.width * 0.06,
                color: isSelected
                    ? AppColors.primaryYellow
                    : (isDark ? Colors.grey[400] : Colors.grey[600]),
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.home, // Fallback icon
                  size: size.width * 0.07,
                  color: isSelected
                      ? AppColors.primaryYellow
                      : (isDark ? Colors.grey[400] : Colors.grey[600]),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.003),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: size.width * 0.025,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.primaryYellow
                    : (isDark ? Colors.grey[400] : Colors.grey[600]),
                fontFamily: "Font3",
              ),
            ),
          ],
        ),
      ),
    );
  }
}