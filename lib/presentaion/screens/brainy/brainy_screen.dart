// presentation/screens/brainy/brainy_screen.dart
import 'package:flutter/material.dart';
import '../../../config/Colors/AppColors.dart';


class BrainyScreen extends StatelessWidget {
  const BrainyScreen({super.key});

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
              Icons.psychology,
              size: size.width * 0.2,
              color: AppColors.secondaryPurple,
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              "Brainy Zone",
              style: theme.textTheme.headlineLarge?.copyWith(
                fontSize: size.width * 0.08,
                fontWeight: FontWeight.bold,
                fontFamily: "Font1",
                color: AppColors.secondaryPurple,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              "Coming Soon! 🧠\nYour study companion awaits",
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