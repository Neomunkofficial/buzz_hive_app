// presentation/screens/onboarding_flow/onboarding_phone_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/Colors/AppColors.dart';
import '../../../../core/services/firebase_auth_service.dart';
import '../../../../state/onboarding_provider.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input_field.dart';
import 'onboarding_otp_screen.dart';
import 'widgets/onboarding_progress.dart';

class OnboardingPhoneScreen extends StatefulWidget {
  const OnboardingPhoneScreen({super.key});

  @override
  State<OnboardingPhoneScreen> createState() => _OnboardingPhoneScreenState();
}

class _OnboardingPhoneScreenState extends State<OnboardingPhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  String countryCode = "+91";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const OnboardingProgress(step: 1),
                const SizedBox(height: 60),

                SizedBox(
                  height: size.height * 0.28,
                  child: Image.asset(
                    "assets/images/phone_asking.png",
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 24),

                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Slide us your ",
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Font3",
                        ),
                      ),
                      TextSpan(
                        text: "digits",
                        style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Font1",
                          color: AppColors.primaryPink,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 0),

                Text(
                  "Don’t worry, we’re not your ex, we won’t blow up your phone.",
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
                ),

                const SizedBox(height: 28),

                Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      Expanded(
                        child: AppInputField(
                          hintText: "Phone No",
                          controller: _phone,
                          fontFamily: "Font4",
                          keyboardType: TextInputType.phone,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return "Enter your phone number";
                            }
                            if (v.length < 8) {
                              return "Enter a valid phone";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                AppButton(
                  text: "My digits for you",
                  backgroundColor: AppColors.primaryYellow,
                  textColor: AppColors.lightText,
                  width: size.width * 0.7,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    /// ✅ sanitize phone input
                    String input = _phone.text.trim();
                    if (input.startsWith("0")) input = input.substring(1);
                    if (input.startsWith("+")) input = input.replaceFirst("+", "");

                    final phoneNumber = "$countryCode$input";

                    context.read<OnboardingProvider>().setPhone(phoneNumber);

                    try {
                      await FirebaseAuthService().sendOtp(
                        phoneNumber,
                            (verificationId) {
                          context
                              .read<OnboardingProvider>()
                              .setVerificationId(verificationId);
                        },
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OnboardingOtpScreen(),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to send OTP: $e")),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
