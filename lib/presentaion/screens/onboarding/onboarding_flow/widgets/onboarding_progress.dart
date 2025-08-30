// presentation/screens/onboarding_flow/widgets/onboarding_progress.dart
import 'package:flutter/material.dart';

class OnboardingProgress extends StatelessWidget {
  final int step; // 1..8
  const OnboardingProgress({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    final pct = step / 8;
    return Column(
      children: [
        Text("Step $step of 8", style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: pct),
        const SizedBox(height: 16),
      ],
    );
  }
}
