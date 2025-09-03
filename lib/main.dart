import 'package:buzz_hive_app/presentaion/screens/home/home_screen.dart';
import 'package:buzz_hive_app/presentaion/screens/onboarding/onboarding_flow/onboarding_phone_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'config/theme/app_theme.dart';
import 'presentaion/screens/onboarding/landing_screen.dart';
import 'state/onboarding_provider.dart';
import 'package:provider/provider.dart';
import 'presentaion/screens/onboarding/signup_screen.dart'; // ✅ new
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // generated via flutterfire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // required for async
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // initialize Firebase
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );

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
        '/home': (_) => const HomeScreen(),
        '/onboarding/phone': (_) => const OnboardingPhoneScreen(),
        '/signup': (_) => const SignupScreen(), // ✅ added
      },
    );
  }
}
