// presentation/screens/onboarding_flow/widgets/onboarding_progress.dart
import 'package:flutter/material.dart';
import '../../../../../config/Colors/AppColors.dart';

class OnboardingProgress extends StatelessWidget {
  final int step; // 1..8
  const OnboardingProgress({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    final pct = step / 8;
    return Column(
      children: [
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: pct,
          color: AppColors.primaryYellow,
          backgroundColor: AppColors.primaryYellow.withOpacity(0.2),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}
