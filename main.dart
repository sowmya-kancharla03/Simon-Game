import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SimonGameApp());
}

class SimonGameApp extends StatelessWidget {
  const SimonGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simon Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}