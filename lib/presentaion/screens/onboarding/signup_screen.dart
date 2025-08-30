import 'package:flutter/material.dart';
import '../../../config/Colors/AppColors.dart';
import '../../widgets/app_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // ✅ Top Illustration
              Center(
                child: Image.asset(
                  "assets/images/signin_image.png", // make sure this path exists
                  height: 250,
                ),
              ),

              const SizedBox(height: 24),

              // ✅ Heading with two fonts
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Ready to vibe? Join the\n",
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        fontFamily: "Font3", // your custom font for line 1
                      ),
                    ),
                    TextSpan(
                      text: "Hive",
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Font1", // your second custom font
                        color: AppColors.primaryPink,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              // ✅ Buttons (keeping size & position)
              AppButton(
                text: "Use Mobile Number",
                backgroundColor: AppColors.primaryYellow,
                textColor: AppColors.lightText,
                width: 250,
                onPressed: () {
                  print("Navigate to Signup form with Mobile");
                  Navigator.pushNamed(context, '/onboarding/phone');
                },
              ),

              const SizedBox(height: 16),

              AppButton(
                text: "Use Google",
                backgroundColor: AppColors.secondaryPurple,
                textColor: AppColors.lightText,
                width: 250,
                onPressed: () {
                  print("Navigate to Signup form with Google");
                },
              ),

              const SizedBox(height: 130),

              // ✅ Footer text
              Text(
                "New here? Don’t worry, you’ll fit right in",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
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
