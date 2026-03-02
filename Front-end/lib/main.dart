import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const SejiwaApp());
}

class SejiwaApp extends StatelessWidget {
  const SejiwaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sejiwa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
