// presentation/screens/onboarding_flow/widgets/screen_scaffold.dart
import 'package:flutter/material.dart';

class OnboardingScreenScaffold extends StatelessWidget {
  final Widget child;
  const OnboardingScreenScaffold({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: child,
        ),
      ),
    );
  }
}
