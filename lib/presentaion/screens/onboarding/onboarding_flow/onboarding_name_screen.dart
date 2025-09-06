// presentation/screens/onboarding_flow/onboarding_name_screen.dart
import 'package:buzz_hive_app/presentaion/screens/onboarding/onboarding_flow/widgets/onboarding_progress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/Colors/AppColors.dart';
import '../../../../state/onboarding_provider.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input_field.dart';
// NEXT screen (college). update import if different:
import 'onboarding_college_screen.dart';

class OnboardingNameScreen extends StatefulWidget {
  const OnboardingNameScreen({super.key});

  @override
  State<OnboardingNameScreen> createState() => _OnboardingNameScreenState();
}

class _OnboardingNameScreenState extends State<OnboardingNameScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();

  String? _gender;

  @override
  void dispose() {
    _nameController.dispose();
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext ctx) async {
    // Pick date with native picker. Default to 18 years back so user selects realistic DOB.
    final now = DateTime.now();
    final initial = DateTime(now.year - 18, now.month, now.day);
    final firstDate = DateTime(now.year - 100);
    final lastDate = DateTime(now.year);

    final picked = await showDatePicker(
      context: ctx,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: AppColors.primaryYellow, // header / selected color
              onPrimary: Colors.black,
              surface: theme.scaffoldBackgroundColor,
              onSurface: theme.textTheme.bodyLarge?.color,
            ),
            dialogBackgroundColor: theme.scaffoldBackgroundColor,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _dayController.text = picked.day.toString().padLeft(2, '0');
      _monthController.text = picked.month.toString().padLeft(2, '0');
      _yearController.text = picked.year.toString();
    }
  }

  Future<void> _submitAndNext() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final dob = "${_yearController.text.trim()}-${_monthController.text.trim().padLeft(2, '0')}-${_dayController.text.trim().padLeft(2, '0')}";
    final gender = _gender;

    // Save in provider
    context.read<OnboardingProvider>().setFirstName(name);
    context.read<OnboardingProvider>().setDateOfBirth(dob);
    context.read<OnboardingProvider>().setGender(gender);

    // Navigate to college screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const OnboardingCollegeScreen(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    // Dropdown style matching AppInputField colors
    final inputFill = isDark ? Colors.grey.shade900 : Colors.white;
    final borderColor =
    isDark ? Colors.grey.shade600 : AppColors.lightText.withOpacity(0.3);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Progress bar
                const OnboardingProgress(step: 3),

                const SizedBox(height: 30),

                // Illustration
                SizedBox(
                  height: size.height * 0.26,
                  child: Image.asset(
                    "assets/images/name_screen_image.png",
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 24),

                // Heading
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Quick intro, ",
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Font3",
                        ),
                      ),
                      TextSpan(
                        text: "bestie.",
                        style: const TextStyle(
                          fontSize: 36,
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
                  "Let the Hive know who you are",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),

                const SizedBox(height: 20),

                // Form fields
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Name
                      AppInputField(
                        hintText: "What should we call you? 👀",
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        validator: (v) =>
                        v == null || v.trim().isEmpty ? "Enter name" : null,
                        // default full width
                      ),
                      const SizedBox(height: 18),

                      // Birthday row: 3 small boxes + optional date picker trigger
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppInputField(
                              hintText: "DD",
                              controller: _dayController,
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              validator: (v) =>
                              v == null || v.isEmpty ? "DD" : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: AppInputField(
                              hintText: "MM",
                              controller: _monthController,
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              validator: (v) =>
                              v == null || v.isEmpty ? "MM" : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: AppInputField(
                              hintText: "YYYY",
                              controller: _yearController,
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              validator: (v) =>
                              v == null || v.isEmpty ? "YYYY" : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Date picker icon button (opens date selector)
                          SizedBox(
                            height: 46,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryPink,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () => _pickDate(context),
                              child: const Icon(Icons.calendar_today_outlined),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // Gender / Vibe dropdown
                      // Gender dropdown
                      DropdownButtonFormField<String>(
                        value: _gender,
                        hint: const Text("Select your gender ⚧"),
                        items: [
                          {"label": "Male", "value": "male"},
                          {"label": "Female", "value": "female"},
                          {"label": "Other", "value": "other"},
                          {"label": "Prefer not to say", "value": "prefer_not_to_say"},
                        ].map((g) {
                          return DropdownMenuItem<String>(
                            value: g["value"],
                            child: Text(
                              g["label"]!,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _gender = val),
                        validator: (v) => v == null ? "Please select" : null,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: inputFill,
                          hintStyle: const TextStyle(fontFamily: "Font2"),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primaryYellow,
                              width: 2,
                            ),
                          ),
                        ),
                        dropdownColor: isDark ? Colors.grey.shade900 : Colors.white,
                        style: TextStyle(
                          fontFamily: "Font2",
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),


                      const SizedBox(height: 30),

                      // Submit
                      AppButton(
                        text: "Lock it in ➝",
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
