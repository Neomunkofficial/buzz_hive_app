// main.dart
import 'package:buzz_hive_app/presentaion/screens/onboarding/onboarding_flow/onboarding_phone_screen.dart';
import 'package:flutter/material.dart';
import 'config/theme/app_theme.dart';
import 'presentaion/screens/onboarding/landing_screen.dart';
import 'state/onboarding_provider.dart';
import 'package:provider/provider.dart'; // add provider:^6.x in pubspec

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => OnboardingProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buzz Hive',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const LandingScreen(),
      routes: {
        '/onboarding/phone': (_) => const OnboardingPhoneScreen(),
        // We’ll push the rest with MaterialPageRoute to allow passing args cleanly.
      },
    );
  }
}
