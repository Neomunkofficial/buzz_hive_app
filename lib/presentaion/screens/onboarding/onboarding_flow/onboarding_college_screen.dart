import 'dart:convert';
import 'package:buzz_hive_app/presentaion/screens/onboarding/onboarding_flow/widgets/onboarding_progress.dart';
import 'package:buzz_hive_app/state/onboarding_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../../config/Colors/AppColors.dart';
import '../../../widgets/app_button.dart';
import 'onboarding_icard_screen.dart';

class OnboardingCollegeScreen extends StatefulWidget {
  const OnboardingCollegeScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingCollegeScreen> createState() =>
      _OnboardingCollegeScreenState();
}

class _OnboardingCollegeScreenState extends State<OnboardingCollegeScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedCollegeId;
  String? _selectedDepartmentId;
  String? _graduationYear;

  List<Map<String, String>> _colleges = [];
  List<Map<String, String>> _departments = [];

  final List<String> _years = List.generate(10, (i) => "${2025 + i}");

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchColleges();
  }

  Future<void> _fetchColleges() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not authenticated");
      }

      final token = await user.getIdToken();
      print("🔑 Firebase Token: ${token?.substring(0, 50)}...");

      final res = await http.get(
        Uri.parse("http://192.168.1.10:5000/api/colleges/"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("📡 Response Status: ${res.statusCode}");
      print("📡 Response Body: ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List<dynamic>;

        final colleges = data.map<Map<String, String>>((c) {
          return {
            "id": c["college_id"].toString(),
            "name": c["name"].toString(),
          };
        }).toList();

        setState(() {
          _colleges = colleges;
          _loading = false;
        });
      } else if (res.statusCode == 403) {
        throw Exception("Access denied. Please contact admin to assign you a role.");
      } else {
        final errorData = jsonDecode(res.body);
        throw Exception(errorData["error"] ?? "Failed to fetch colleges");
      }
    } catch (e) {
      print("❌ Error fetching colleges: $e");
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _fetchDepartments(String collegeId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final token = await user.getIdToken();
      final res = await http.get(
        Uri.parse("http://192.168.1.10:5000/api/colleges/$collegeId/departments"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("📡 Departments Response Status: ${res.statusCode}");
      print("📡 Departments Response Body: ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List<dynamic>;

        final departments = data.map<Map<String, String>>((d) {
          return {
            "id": d["department_id"].toString(),
            "name": d["name"].toString(),
          };
        }).toList();

        setState(() {
          _departments = departments;
          _selectedDepartmentId = null;
        });
      }
    } catch (e) {
      print("❌ Error fetching departments: $e");
    }
  }

  void _onCollegeSelected(String? collegeId) {
    setState(() {
      _selectedCollegeId = collegeId;
      _selectedDepartmentId = null;
      _departments = [];
    });
    if (collegeId != null) {
      _fetchDepartments(collegeId);
    }
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<OnboardingProvider>();

      // Store the selected college and department IDs
      provider.setCollege(_selectedCollegeId ?? "");
      provider.setProgram(_selectedDepartmentId ?? "");
      provider.setYear(_graduationYear ?? "");

      print("🔄 Storing college data:");
      print("College ID: $_selectedCollegeId");
      print("Department ID: $_selectedDepartmentId");
      print("Year: $_graduationYear");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const OnboardingICardScreen(),
        ),
      );
    }
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            "Failed to load colleges",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _error ?? "Unknown error occurred",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.red,
              ),
            ),
          ),
          const SizedBox(height: 24),
          AppButton(
            text: "Retry",
            backgroundColor: AppColors.primaryYellow,
            textColor: Colors.black,
            onPressed: _fetchColleges,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    final inputFill = isDark ? Colors.grey.shade900 : Colors.white;
    final borderColor =
    isDark ? Colors.grey.shade600 : AppColors.lightText.withOpacity(0.3);

    return Scaffold(
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? _buildErrorWidget()
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const OnboardingProgress(step: 4),
              const SizedBox(height: 20),

              SizedBox(
                height: size.height * 0.26,
                child: Image.asset(
                  "assets/images/collge_screen_image.png",
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),

              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Flex your ",
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Font3",
                      ),
                    ),
                    const TextSpan(
                      text: "campus",
                      style: TextStyle(
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
              const SizedBox(height: 1),
              Text(
                "Drop your college cred details here",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 30),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // College dropdown
                    CustomDropdown(
                      label: "Campus you are buzzing from? 🎓",
                      value: _selectedCollegeId,
                      items: _colleges,
                      onChanged: _onCollegeSelected,
                      validator: (v) => v == null
                          ? "Please select your college"
                          : null,
                      inputFill: inputFill,
                      borderColor: borderColor,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),

                    // Department dropdown (only shows if college selected)
                    if (_departments.isNotEmpty)
                      CustomDropdown(
                        label: "Your major hustle? 📚",
                        value: _selectedDepartmentId,
                        items: _departments,
                        onChanged: (v) =>
                            setState(() => _selectedDepartmentId = v),
                        validator: (v) => v == null
                            ? "Please select your major"
                            : null,
                        inputFill: inputFill,
                        borderColor: borderColor,
                        isDark: isDark,
                      ),
                    const SizedBox(height: 16),

                    // Graduation year dropdown
                    CustomDropdown(
                      label: "When's your squad graduating? 🎉",
                      value: _graduationYear,
                      items: _years
                          .map((y) => {"id": y, "name": y})
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _graduationYear = v),
                      validator: (v) => v == null
                          ? "Please select graduation year"
                          : null,
                      inputFill: inputFill,
                      borderColor: borderColor,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              AppButton(
                text: "Lock it in ➝",
                backgroundColor: AppColors.primaryYellow,
                textColor: Colors.black,
                width: size.width * 0.5,
                onPressed: _onSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<Map<String, String>> items;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;
  final Color inputFill;
  final Color borderColor;
  final bool isDark;

  const CustomDropdown({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    required this.inputFill,
    required this.borderColor,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: value,
      validator: validator,
      hint: Text(label, style: const TextStyle(fontFamily: "Font2")),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item["id"],
          child: Text(
            item["name"]!,
            overflow: TextOverflow.ellipsis,
            // ADD THIS: Force the text to stay on one line
            maxLines: 1,
            // ADD THIS: Prevent the text from wrapping
            softWrap: false,
            style: TextStyle(
              fontFamily: "Font2",
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: inputFill,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
          borderSide: const BorderSide(
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
    );
  }
}