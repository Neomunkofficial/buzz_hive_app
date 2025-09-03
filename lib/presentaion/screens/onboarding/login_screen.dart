import 'package:flutter/material.dart';
import '../../../config/Colors/AppColors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_input_field.dart';
import '../../../data/repositories/auth_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  /// ✅ Login Logic
  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    final authRepo = AuthRepository();
    final response = await authRepo.login(
      phoneController.text.trim(),
      passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (response.containsKey("token")) {
      // ✅ Navigate to home if login successful
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, "/home");
    } else if (response.containsKey("error")) {
      // ✅ Show backend error in SnackBar
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response['error'],
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.primaryPink, // match your app theme
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else {
      // ✅ Fallback for unknown errors
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An unknown error occurred. Try again."),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                Image.asset(
                  "assets/images/login_image.png",
                  height: 230,
                ),

                const SizedBox(height: 24),

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
                  "Let's get you in.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 28),

                /// ✅ Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppInputField(
                        hintText: "Phone No",
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your phone number";
                          }
                          return null;
                        },
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

                /// ✅ Button - FIXED
                AppButton(
                  text: _isLoading ? "Logging in..." : "Dive Back In",
                  backgroundColor: AppColors.primaryYellow,
                  textColor: Colors.black,
                  width: 200,
                  // ✅ SOLUTION: Pass the function reference directly
                  onPressed: _isLoading ? null : _handleLogin,
                ),

                const SizedBox(height: 50),

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