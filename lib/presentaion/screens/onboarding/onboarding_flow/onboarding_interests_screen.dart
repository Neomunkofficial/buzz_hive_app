import 'package:flutter/material.dart';
import '../../../../config/Colors/AppColors.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_search_bar.dart';
import 'onboarding_photo_screen.dart';
import 'widgets/onboarding_progress.dart';

class OnboardingInterestsScreen extends StatefulWidget {
  final List<String> interests; // from backend

  const OnboardingInterestsScreen({super.key, required this.interests});

  @override
  State<OnboardingInterestsScreen> createState() =>
      _OnboardingInterestsScreenState();
}

class _OnboardingInterestsScreenState extends State<OnboardingInterestsScreen> {
  final Set<String> _selectedInterests = {};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
  }

  void _submitInterests() {
    debugPrint("Selected Interests: $_selectedInterests");
    // TODO: Call Node.js API to save interest
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingPhotoScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    // Filter list
    final filteredInterests = widget.interests
        .where((i) => i.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// 🔼 Top Section (non-scrollable)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const OnboardingProgress(step: 6),

                  // Back button

                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Show off your ",
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontSize: 22,
                            fontFamily: "Font3",
                            color: isDark
                                ? AppColors.darkText
                                : AppColors.lightText,
                          ),
                        ),
                        const TextSpan(
                          text: "vibe",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Font1",
                            color: AppColors.primaryPink,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    "Flex your talents & interests. The Hive wants to know",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color:
                      isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),

                  const SizedBox(height: 16),

                  AppSearchBar(
                    controller: _searchController,
                    onChanged: (query) {
                      setState(() => _searchQuery = query);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// 🔽 Scrollable Interests Section
            Expanded(
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: filteredInterests.map((interest) {
                    final isSelected = _selectedInterests.contains(interest);
                    return GestureDetector(
                      onTap: () => _toggleInterest(interest),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _getColorForInterest(interest)
                              : (isDark
                              ? Colors.grey[700]
                              : Colors.grey[300]),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          interest,
                          style: TextStyle(
                            color: isSelected
                                ? (isDark ? AppColors.darkText : AppColors.lightText)
                                : (isDark
                                ? AppColors.darkText
                                : AppColors.lightText),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Font3",
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            /// 🔽 Bottom Button
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              child: AppButton(
                text: "Lock it in ➝",
                backgroundColor: AppColors.primaryYellow,
                textColor: AppColors.lightText,
                width: size.width * 0.5,
                onPressed: _submitInterests,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Assign colors based on hash for variety
  Color _getColorForInterest(String interest) {
    final colors = [
      AppColors.primaryYellow,
      AppColors.primaryPink,
      AppColors.secondaryPurple,
      AppColors.secondaryBlue,
    ];
    return colors[interest.hashCode % colors.length];
  }
}
