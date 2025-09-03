// presentation/screens/onboarding_flow/onboarding_otp_screen.dart
import 'package:buzz_hive_app/presentaion/screens/onboarding/onboarding_flow/widgets/onboarding_progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pinput/pinput.dart';

import '../../../../config/Colors/AppColors.dart';
import '../../../../core/services/firebase_auth_service.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../state/onboarding_provider.dart';
import '../../../widgets/app_button.dart';
import 'onboarding_name_screen.dart';

class OnboardingOtpScreen extends StatefulWidget {
  const OnboardingOtpScreen({super.key});

  @override
  State<OnboardingOtpScreen> createState() => _OnboardingOtpScreenState();
}

class _OnboardingOtpScreenState extends State<OnboardingOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingProvider = context.watch<OnboardingProvider>();
    final phone = onboardingProvider.state.phone;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    final defaultPinTheme = PinTheme(
      width: 50,
      height: 56,
      textStyle: theme.textTheme.titleLarge?.copyWith(
        color: isDark ? AppColors.darkText : AppColors.lightText,
        fontFamily: "Font1",
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white24 : Colors.black26,
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const OnboardingProgress(step: 2),
                const SizedBox(height: 60),
                SizedBox(
                  height: size.height * 0.28,
                  child: Image.asset(
                    "assets/images/otp_image.png",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 24),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Check your ",
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Font3",
                        ),
                      ),
                      TextSpan(
                        text: "messages",
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Font1",
                          color: AppColors.primaryPink,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text.rich(
                  TextSpan(
                    text:
                    "Don't ghost us. We just dropped you a secret code at ",
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
                    children: [
                      TextSpan(
                        text: phone,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.secondaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Form(
                  key: _formKey,
                  child: Pinput(
                    length: 6,
                    controller: _otpController,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        border: Border.all(
                          color: AppColors.primaryYellow,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Enter OTP";
                      if (v.length < 6) return "Invalid OTP";
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // TODO: Resend OTP functionality
                  },
                  child: Text(
                    "Didn't get code?",
                    style: theme.textTheme.bodySmall?.copyWith(
                      decoration: TextDecoration.underline,
                      fontFamily: "Font3",
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                AppButton(
                  text: _isLoading ? "Verifying..." : "Prove I'm not a bot",
                  backgroundColor: AppColors.primaryYellow,
                  textColor: Colors.black,
                  width: size.width * 0.7,
                  onPressed: _isLoading
                      ? null
                      : () => _verifyOtp(context, onboardingProvider, phone),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _verifyOtp(
      BuildContext context,
      OnboardingProvider onboardingProvider,
      String? phone,
      ) async {
    if (!_formKey.currentState!.validate()) return;
    if (phone == null || phone.isEmpty) {
      _showError(context, "Phone number missing. Please restart onboarding.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final verificationId = onboardingProvider.state.verificationId;
      if (verificationId == null) {
        throw Exception("No verification ID found. Please restart verification.");
      }

      /// ✅ Step 1: Firebase OTP verification
      final userCredential = await FirebaseAuthService().verifyOtp(
        _otpController.text.trim(),
        verificationId: verificationId,
      );

      final idToken = await userCredential.user?.getIdToken();
      if (idToken == null) throw Exception("Failed to get Firebase ID Token");

      debugPrint("✅ Firebase UID: ${userCredential.user?.uid}");
      debugPrint("✅ Firebase ID Token: $idToken");

      /// ✅ Step 2: Send Firebase ID token + phone to backend
      final response = await AuthRepository().signupOrLoginWithFirebase(
        phone: phone,
        idToken: idToken,
      );

      debugPrint("✅ Backend response: $response");

      if (response.containsKey("error")) {
        throw Exception("Backend error: ${response["error"]}");
      }

      final backendToken = response["token"];
      if (backendToken == null) {
        throw Exception("No backend token received.");
      }

      onboardingProvider.setBackendToken(backendToken);

      /// ✅ Step 3: Navigate to next screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingNameScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      _handleFirebaseError(context, e);
    } catch (e) {
      debugPrint("❌ Error in OTP verification: $e");
      _showError(context, "Verification failed: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleFirebaseError(BuildContext context, FirebaseAuthException e) {
    String errorMessage;
    switch (e.code) {
      case 'invalid-verification-code':
        errorMessage = "Invalid OTP. Please check and try again.";
        break;
      case 'session-expired':
        errorMessage = "OTP has expired. Please request a new one.";
        break;
      case 'too-many-requests':
        errorMessage = "Too many attempts. Try again later.";
        break;
      default:
        errorMessage = "Verification failed: ${e.message}";
    }
    _showError(context, errorMessage);
  }

  void _showError(BuildContext context, String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
      );
    }
  }
}
