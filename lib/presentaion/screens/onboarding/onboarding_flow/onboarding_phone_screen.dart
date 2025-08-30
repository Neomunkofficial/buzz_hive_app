// presentation/screens/onboarding_flow/onboarding_phone_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/Colors/AppColors.dart';
import '../../../../state/onboarding_provider.dart';
import '../../../widgets/app_input_field.dart';
import '../../../widgets/app_button.dart';
import 'widgets/screen_scaffold.dart';
import 'onboarding_otp_screen.dart';

class OnboardingPhoneScreen extends StatefulWidget {
  const OnboardingPhoneScreen({super.key});

  @override
  State<OnboardingPhoneScreen> createState() => _OnboardingPhoneScreenState();
}

class _OnboardingPhoneScreenState extends State<OnboardingPhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: OnboardingScreenScaffold(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // you can add an illustration here if needed
            Text(
              "Verify your number",
              style: theme.textTheme.headlineLarge?.copyWith(fontSize: 24, fontFamily: 'Font3'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: AppInputField(
                hintText: "Phone number",
                controller: _phone,
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return "Enter your phone number";
                  if (v.length < 8) return "Enter a valid phone";
                  return null;
                },
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              text: "Send OTP",
              backgroundColor: AppColors.primaryYellow,
              textColor: Colors.black,
              width: 240,
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                context.read<OnboardingProvider>().setPhone(_phone.text.trim());
                // TODO: await AuthService().sendOtp(_phone.text.trim());
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OnboardingOtpScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
