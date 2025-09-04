import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/Colors/AppColors.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_search_bar.dart';
import 'onboarding_photo_screen.dart';
import 'widgets/onboarding_progress.dart';
import '../../../../state/onboarding_provider.dart';

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
    final provider = Provider.of<OnboardingProvider>(context, listen: false);

    // ✅ Update provider with selected interests
    provider.setInterests(_selectedInterests.toList());

    // ✅ Debug prints for assurance
    debugPrint("🎯 Selected Interests (local): $_selectedInterests");
    debugPrint("📦 Provider Interests: ${provider.state.interests}");

    // Move to next onboarding step
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
            /// 🔼 Top Section with 3D effect container
            Container(

              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.15),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: isDark
                        ? Colors.white.withOpacity(0.02)
                        : Colors.white.withOpacity(0.8),
                    offset: const Offset(0, -2),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
                border: Border.all(
                  color: isDark
                      ? Colors.grey.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const OnboardingProgress(step: 6),

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

                  const SizedBox(height: 8),

                  // 🎨 Use a Wrap widget to prevent overflow and arrange children dynamically.
                  Wrap(
                    // Aligns children with space between them on the horizontal axis.
                    alignment: WrapAlignment.spaceEvenly,
                    // Vertically centers the text and the counter badge.
                    crossAxisAlignment: WrapCrossAlignment.center,
                    // Adds vertical space between lines if the content wraps.
                    runSpacing: 10.0,
                    children: [
                      // The main descriptive text.
                      Text(
                        "Flex your talents & interests. The Hive wants to know",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),

                      // The counter badge, which appears only when interests are selected.
                      if (_selectedInterests.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryYellow.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primaryYellow.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: AppColors.primaryYellow,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "${_selectedInterests.length} selected",
                                style: TextStyle(
                                  color: isDark ? AppColors.darkText : AppColors.lightText,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Font3",
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  AppSearchBar(
                    controller: _searchController,
                    onChanged: (query) {
                      setState(() => _searchQuery = query);
                    },
                  ),


                ],
              ),
            ),




            /// 🔽 Scrollable Interests Section - Redesigned Pills
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                child: Wrap(
                  spacing: 8, // Reduced spacing like in reference
                  runSpacing: 8, // Reduced spacing like in reference
                  children: filteredInterests.map((interest) {
                    final isSelected = _selectedInterests.contains(interest);
                    return GestureDetector(
                      onTap: () => _toggleInterest(interest),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14, // Smaller padding like reference
                          vertical: 8,    // Smaller padding like reference
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _getColorForInterest(interest)
                              : (isDark
                              ? Colors.grey[800]?.withOpacity(0.6)
                              : Colors.grey[200]?.withOpacity(0.8)),
                          borderRadius: BorderRadius.circular(18), // Smaller radius like reference
                          border: Border.all(
                            color: isSelected
                                ? _getColorForInterest(interest).withOpacity(0.3)
                                : (isDark
                                ? Colors.grey[600]!.withOpacity(0.3)
                                : Colors.grey[400]!.withOpacity(0.3)),
                            width: 1,
                          ),
                          boxShadow: isSelected
                              ? [
                            BoxShadow(
                              color: _getColorForInterest(interest).withOpacity(0.3),
                              offset: const Offset(0, 2),
                              blurRadius: 8,
                              spreadRadius: 0,
                            ),
                          ]
                              : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              offset: const Offset(0, 1),
                              blurRadius: 3,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Text(
                          interest,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : (isDark
                                ? AppColors.darkText.withOpacity(0.8)
                                : AppColors.lightText.withOpacity(0.8)),
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            fontFamily: "Font3",
                            fontSize: 13, // Smaller font size like reference
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            /// 🔽 Bottom Button with enhanced design
            Container(
              padding: const EdgeInsets.only(bottom: 24, top: 16),
              margin: const EdgeInsets.symmetric(horizontal: 22),
              child: AppButton(
                text: "Lock it in ➝",
                backgroundColor: AppColors.primaryYellow,
                textColor: AppColors.lightText,
                width: size.width * 0.6,
                height: 52,
                borderRadius: 26,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                onPressed: _selectedInterests.isEmpty ? null : _submitInterests,
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