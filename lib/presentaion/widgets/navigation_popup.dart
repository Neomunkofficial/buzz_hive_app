// presentation/widgets/navigation_popup.dart
import 'dart:ui';
import '../../config/Colors/AppColors.dart';
import 'package:flutter/material.dart';

class NavigationPopup extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String) onNavigate;

  const NavigationPopup({
    super.key,
    required this.onClose,
    required this.onNavigate,
  });

  @override
  State<NavigationPopup> createState() => _NavigationPopupState();
}

class _NavigationPopupState extends State<NavigationPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: widget.onClose,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            color: Colors.black.withOpacity(0.4 * _fadeAnimation.value),
            child: Stack(
              children: [
                // Floating card positioned above navigation bar
                Positioned(
                  bottom: size.height * 0.0001, // Position above navbar
                  left: size.width * 0.05,
                  right: size.width * 0.05,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: size.height * 0.45,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFFFB347), // Orange
                            Color(0xFFFFEB3B), // Yellow
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(size.width * 0.05),
                      child: Column(
                        children: [
                          // Top card (Ghost Post)
                          Container(
                            width: double.infinity,
                            height: size.height * 0.15,
                            margin: EdgeInsets.only(bottom: size.height * 0.02),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFF9C27B0), // Purple
                                  Color(0xFF673AB7), // Deep purple
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  widget.onNavigate('/ghost-post');
                                  widget.onClose();
                                },
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(size.width * 0.03),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          "👻",
                                          style: TextStyle(fontSize: size.width * 0.08),
                                        ),
                                      ),
                                      SizedBox(height: size.height * 0.01),
                                      Text(
                                        "Ghost Post",
                                        style: TextStyle(
                                          fontSize: size.width * 0.045,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          fontFamily: "Font3",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Bottom grid (2x2)
                          Expanded(
                            child: Row(
                              children: [
                                // Left column
                                Expanded(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: _QuickAccessMiniCard(
                                          title: "Collab",
                                          emoji: "🤝",
                                          color: AppColors.primaryPink,
                                          onTap: () {
                                            widget.onNavigate('/collab');
                                            widget.onClose();
                                          },
                                        ),
                                      ),
                                      SizedBox(height: size.height * 0.01),
                                      Expanded(
                                        child: _QuickAccessMiniCard(
                                          title: "Circle",
                                          emoji: "🏠",
                                          color: AppColors.primaryPink,
                                          onTap: () {
                                            widget.onNavigate('/circle');
                                            widget.onClose();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: size.width * 0.03),
                                // Right column
                                Expanded(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: _QuickAccessMiniCard(
                                          title: "Buzz Picks",
                                          emoji: "💡",
                                          color: AppColors.primaryPink,
                                          onTap: () {
                                            widget.onNavigate('/buzz-picks');
                                            widget.onClose();
                                          },
                                        ),
                                      ),
                                      SizedBox(height: size.height * 0.01),
                                      Expanded(
                                        child: _QuickAccessMiniCard(
                                          title: "ThriftX",
                                          emoji: "🛍️",
                                          color: AppColors.primaryPink,
                                          onTap: () {
                                            widget.onNavigate('/thriftx');
                                            widget.onClose();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _QuickAccessMiniCard extends StatelessWidget {
  final String title;
  final String emoji;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessMiniCard({
    required this.title,
    required this.emoji,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  emoji,
                  style: TextStyle(fontSize: size.width * 0.06),
                ),
                SizedBox(height: size.height * 0.005),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: size.width * 0.03,
                    color: Colors.white,
                    fontFamily: "Font3",
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}