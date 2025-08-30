import 'package:flutter/material.dart';
import '../../../config/Colors/AppColors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView( // ✅ prevents overflow
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                // ✅ Login Image
                Image.asset(
                  "assets/images/login_image.png",
                  height: 230,
                ),

                const SizedBox(height: 24),

                // ✅ Title
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Back to the ",
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Font3",
                        ),
                      ),
                      TextSpan(
                        text: "buzz?",
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

                const SizedBox(height: 8),

                Text(
                  "Let’s get you in.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 28),

                // ✅ Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppInputField(
                        hintText: "Phone No",
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      AppInputField(
                        hintText: "Password",
                        controller: passwordController,
                        isPassword: true,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your password";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ✅ Button
                AppButton(
                  text: "Dive Back In",
                  backgroundColor: AppColors.primaryYellow,
                  textColor: Colors.black,
                  width: 200,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print("Phone: ${phoneController.text}, Password: ${passwordController.text}");
                    }
                  },
                ),

                const SizedBox(height: 50),

                // ✅ Lost Password
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Lost the buzz?",
                    style: TextStyle(
                      fontFamily: "Font3",
                      color: AppColors.primaryPink,
                      fontSize: 14,
                    ),
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
