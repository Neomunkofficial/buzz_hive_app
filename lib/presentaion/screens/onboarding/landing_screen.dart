import 'package:buzz_hive_app/presentaion/screens/onboarding/signup_screen.dart';
import 'package:flutter/material.dart';
import '../../../config/Colors/AppColors.dart';
import '../../widgets/app_button.dart';
import 'login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView( // ✅ Prevents overflow
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),

                // ✅ Logo + Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/buzzlogo.png",
                      height: 80,
                    ),
                    Text(
                      "Buzz Hive",
                      style: TextStyle(
                        fontSize: 45,
                        fontFamily: 'Font1',
                        fontWeight: FontWeight.bold,
                        color: theme.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ✅ Subtitle
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Font3',
                    ),
                    children: [
                      TextSpan(
                        text: "Your Campus. ",
                        style: TextStyle(color: AppColors.secondaryPurple),
                      ),
                      TextSpan(
                        text: "Your People. ",
                        style: TextStyle(color: AppColors.secondaryBlue),
                      ),
                      TextSpan(
                        text: "Your Vibe.",
                        style: TextStyle(color: AppColors.primaryPink),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 120),

                // ✅ AppButtons (size preserved)
                AppButton(
                  text: "Create An Account",
                  backgroundColor: AppColors.primaryYellow,
                  textColor: Colors.black,
                  width: 260,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupScreen()),
                    );
                  },
                ),

                const SizedBox(height: 16),

                AppButton(
                  text: "Login to your Account",
                  backgroundColor: AppColors.primaryPink,
                  textColor: AppColors.lightText,
                  width: 273,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                ),

                const SizedBox(height: 120),

                // ✅ Privacy Policy
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text.rich(
                    TextSpan(
                      text: "By Creating account you are agreeing to our ",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        color: theme.brightness == Brightness.light
                            ? Colors.black54
                            : Colors.white70,
                      ),
                      children: [
                        const TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
