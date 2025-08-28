import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Colors/AppColors.dart';

class Landingdark extends StatefulWidget {
  const Landingdark({super.key});

  @override
  State<Landingdark> createState() => _LandingPageState();
}

class _LandingPageState extends State<Landingdark> {

// Function to handle Create Account button press
  void _onCreateAccountPressed() {
    print('Create Account button pressed');
  }

// Function to handle Login button press
  void _onLoginPressed() {
    print('Login button pressed');
  }

// Function to handle Privacy Policy link press
  void _onPrivacyPolicyPressed() {
    print('Privacy Policy link pressed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Darkmode,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height:60),

// Logo and App Name
              Padding(
                padding: EdgeInsets.only(right:25.0),
                child: Column(
                  children: [
                    const SizedBox(height:15),
                    Row(

                      mainAxisAlignment: MainAxisAlignment.center,


                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/images/buzzlogo.png'),
                          backgroundColor:AppColors.Darkmode ,
                          maxRadius: 40,
                        ),
                        const SizedBox(width: 0.5),
                        const Text(
                          'Buzz Hive',
                          style: TextStyle(
                            fontFamily: 'Font1',
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: AppColors.Lightmode,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),





                    // Tagline
                    Padding(
                      padding: const EdgeInsets.only(left: 28.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Font3',
                            fontSize: 15,
                            letterSpacing: 0.5,
                            color: Color(0xFF9E9E9E),
                            // default color if needed
                          ),
                          children: [
                            TextSpan(
                              text: 'Your Campus.',
                              style: TextStyle(color: AppColors.secondary), // first color
                            ),
                            TextSpan(
                              text: 'Your People.',
                              style: TextStyle(color: AppColors.accent1), // second color
                            ),
                            TextSpan(
                              text: 'Your Vibe.',
                              style: TextStyle(color: AppColors.accent2), // third color
                            ),

                          ],
                        ),
                      ),
                    )

                  ],
                ),
              ),

              const SizedBox(height:120 ,),

// Action Buttons
              Column(
                children: [
// Create Account Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _onCreateAccountPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary, // Yellow/Gold
                        foregroundColor: AppColors.Lightmode,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        shadowColor: Colors.black26,
                      ),
                      child: const Text(
                        'Create An Account',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Font3',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

// Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _onLoginPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent2, // Pink
                        foregroundColor: AppColors.Lightmode,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        shadowColor: Colors.black26,
                      ),
                      child: const Text(
                        'Log In to your Account',
                        style: TextStyle(
                          fontFamily: 'Font3',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height:120),

             // Privacy Policy Text
              GestureDetector(
                onTap: _onPrivacyPolicyPressed,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Font3',
                      fontSize: 12,
                      color:AppColors.Lightmode,
                    ),
                    children: [
                      TextSpan(text: 'By Creating account you are agreeing to our '),

                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: _onPrivacyPolicyPressed,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Font3',
                      fontSize: 12,
                      color: Color(0xFF9E9E9E),
                    ),
                    children: [
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: AppColors.Lightmode,
                        ),
                      ),
                    ],
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}


