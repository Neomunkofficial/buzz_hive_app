import 'package:buzz_hive_app/Colors/AppColors.dart';
import 'package:buzz_hive_app/Screens/Onboarding/LandingPages/LandingPage.dart';
import 'package:flutter/material.dart';

import 'Screens/Onboarding/LandingPages/Landingdark.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor:AppColors.primary,
      ),
      initialRoute:'Landingdark',
      routes: {
        'LandingPage':(_) => LandingPage(),
        'Landingdark':(_) => Landingdark()
      },

    );
  }
}




