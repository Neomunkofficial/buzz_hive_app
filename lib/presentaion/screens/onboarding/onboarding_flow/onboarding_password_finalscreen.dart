// presentation/screens/onboarding_flow/onboarding_password_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/Colors/AppColors.dart';
import '../../../../state/onboarding_provider.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input_field.dart';
import '../../main_navigation_screen.dart';
import 'widgets/onboarding_progress.dart';
// NEXT screen after onboarding

class OnboardingPasswordScreen extends StatefulWidget {
  const OnboardingPasswordScreen({super.key});

  @override
  State<OnboardingPasswordScreen> createState() => _OnboardingPasswordScreenState();
}

class _OnboardingPasswordScreenState extends State<OnboardingPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitAndNext() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final provider = context.read<OnboardingProvider>();
    provider.setEmail(email);
    provider.setPassword(password);

    final success = await provider.submitOnboardingData();

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.submissionError ?? "Something went wrong")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Progress bar
                const OnboardingProgress(step: 8), // last step

                const SizedBox(height: 30),

                // Illustration
                SizedBox(
                  height: size.height * 0.29,
                  child: Image.asset(
                    "assets/images/password_image.png",
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 24),

                // Heading
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Now the, ",
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Font3",
                        ),
                      ),
                      const TextSpan(
                        text: "Final Step",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Font1",
                          color: AppColors.primaryPink,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  "Lets make your account secure so that your roommate wont get access of your crushes",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppInputField(
                        hintText: "Where should we email you?",
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return "Enter your email";
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                            return "Enter valid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),

                      AppInputField(
                        hintText: "Give us that secure combination of words",
                        controller: _passwordController,
                        isPassword: true,
                        validator: (v) => v == null || v.length < 6
                            ? "Min 6 characters"
                            : null,
                      ),
                      const SizedBox(height: 18),

                      AppInputField(
                        hintText: "Retype that again buddy",
                        controller: _confirmPasswordController,
                        isPassword: true,
                        validator: (v) => v != _passwordController.text
                            ? "Passwords do not match"
                            : null,
                      ),

                      const SizedBox(height: 30),

                      AppButton(
                        text: "Buzz In",
                        backgroundColor: AppColors.primaryYellow,
                        textColor: Colors.black,
                        width: size.width * 0.5,
                        onPressed: _submitAndNext,
                      ),
                    ],
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
