// Importing the custom theme definitions
import 'package:animation/theme/theme.dart';
// Importing Flutter's material design package
import 'package:flutter/material.dart';
// Importing the HomeScreen widget
import 'screens/home_screen.dart';

// The main function is the entry point of the Flutter application
void main() {
  // Running the AnimationApp widget
  runApp(const AnimationApp());
}

// The root widget of the application
class AnimationApp extends StatelessWidget {
  // Constructor for the AnimationApp widget
  const AnimationApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Building the MaterialApp widget
    return MaterialApp(
      title: 'Flutter Animation App', // Title of the application
      theme: lightTheme, // Light theme for the app
      darkTheme: darkTheme, // Dark theme for the app
      themeMode: ThemeMode.system, // Theme mode based on system settings
      debugShowCheckedModeBanner: false, // Disables the debug banner
      home: const HomeScreen(), // Sets the HomeScreen as the initial screen
    );
  }
}
