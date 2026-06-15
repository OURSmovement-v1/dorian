import 'package:flutter/material.dart';

import 'screens/landing_screen.dart';

void main() {
  runApp(const DorianApp());
}

class DorianApp extends StatelessWidget {
  const DorianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LandingScreen(),
    );
  }
}
