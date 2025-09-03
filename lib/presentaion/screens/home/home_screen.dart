// presentation/screens/home/home_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../config/Colors/AppColors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: size.height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Buzz Hive",
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontSize: size.width * 0.09,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Font1",
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        color: isDark ? Colors.white : Colors.black,
                        size: size.width * 0.06,
                      ),
                      SizedBox(width: size.width * 0.04),
                      Icon(
                        Icons.menu,
                        color: isDark ? Colors.white : Colors.black,
                        size: size.width * 0.06,
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: size.height * 0.03),

              // Carousel placeholder
              Container(
                width: double.infinity,
                height: size.height * 0.25,
                decoration: BoxDecoration(
                  color: AppColors.primaryPink.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primaryPink.withOpacity(0.3),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        size: size.width * 0.1,
                        color: AppColors.primaryPink.withOpacity(0.6),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Text(
                        "Add Events, Notifications, and\nother things, basically what\nshould be displaying here in\ncarousel form",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: size.width * 0.035,
                          color: AppColors.primaryPink.withOpacity(0.8),
                          fontFamily: "Font3",
                        ),
                      ),
                      SizedBox(height: size.height * 0.015),
                      // Carousel dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          8,
                              (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: index == 0
                                  ? AppColors.primaryPink
                                  : AppColors.primaryPink.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.03),

              // Quick access grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
                children: [
                  _QuickAccessCard(
                    title: "Buzz Events",
                    icon: Icons.local_fire_department,
                    color: AppColors.primaryYellow,
                    textColor: Colors.black,
                    onTap: () {
                      // Navigate to events
                    },
                  ),
                  _QuickAccessCard(
                    title: "NextStep",
                    icon: Icons.school,
                    color: AppColors.secondaryPurple,
                    textColor: Colors.white,
                    onTap: () {
                      // Navigate to career guidance
                    },
                  ),
                  _QuickAccessCard(
                    title: "Steal Deals",
                    icon: Icons.local_offer,
                    color: const Color(0xFF1DB954),
                    textColor: Colors.white,
                    onTap: () {
                      // Navigate to deals
                    },
                  ),
                  _QuickAccessCard(
                    title: "Crush Wall",
                    icon: Icons.favorite,
                    color: AppColors.primaryPink,
                    textColor: Colors.white,
                    onTap: () {
                      // Navigate to crush wall
                    },
                  ),
                ],
              ),

              SizedBox(height: size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: textColor,
                size: size.width * 0.08,
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: size.width * 0.04,
                  color: textColor,
                  fontFamily: "Font3",
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}