// presentation/screens/buzz/buzz_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../config/Colors/AppColors.dart';


class BuzzScreen extends StatelessWidget {
  const BuzzScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rss_feed,
              size: size.width * 0.2,
              color: AppColors.primaryPink,
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              "Buzz Feed",
              style: theme.textTheme.headlineLarge?.copyWith(
                fontSize: size.width * 0.08,
                fontWeight: FontWeight.bold,
                fontFamily: "Font1",
                color: AppColors.primaryPink,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              "Coming Soon! 🚀\nYour social feed will buzz here",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: size.width * 0.04,
                fontFamily: "Font3",
              ),
            ),
          ],
        ),
      ),
    );
  }
}