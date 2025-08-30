// presentation/screens/onboarding_flow/onboarding_otp_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/Colors/AppColors.dart';
import '../../../../state/onboarding_provider.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input_field.dart';
import '../../onboarding/landing_screen.dart'; // optional for back to start
import 'onboarding_name_screen.dart';
import 'widgets/screen_scaffold.dart';

class OnboardingOtpScreen extends StatefulWidget {
  const OnboardingOtpScreen({super.key});

  @override
  State<OnboardingOtpScreen> createState() => _OnboardingOtpScreenState();
}

class _OnboardingOtpScreenState extends State<OnboardingOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final phone = context.watch<OnboardingProvider>().state.phone;
    final theme = Theme.of(context);

    return Scaffold(
      body: OnboardingScreenScaffold(
        child: Column(
          children: [
            Text("OTP sent to $phone", style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: AppInputField(
                hintText: "Enter OTP",
                controller: _otp,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Enter OTP";
                  if (v.length < 4) return "Invalid OTP";
                  return null;
                },
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              text: "Verify",
              backgroundColor: AppColors.primaryYellow,
              textColor: Colors.black,
              width: 200,
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;

                // TODO: final idToken = await AuthService().verifyOtpAndGetIdToken(...);
                // TODO: await AuthRepository(ApiClient()).exchangeFirebaseToken(idToken);

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (_) => const OnboardingNameScreen()),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}
