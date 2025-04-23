import 'package:animation/screens/explict_animation.dart';
import 'package:animation/screens/implict_animation.dart';
import 'package:animation/screens/physics_based_animation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Tracks the selected tab index

  // List of screens for each tab
  final List<Widget> _screens = [
    const ImplicitAnimationsScreen(),
    const ExplicitAnimationScreen(),
    const PhysicsAnimationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Animations',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ), // Professional font styling
        ),
        centerTitle: true, // Center the title for a cleaner look
        backgroundColor: Colors.blueAccent, // Use a professional color
      ),
      body: _screens[_currentIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Highlight the selected tab
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected tab index
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.animation), // Icon for Implicit Animations
            label: 'Implicit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explicit), // Icon for Explicit Animations
            label: 'Explicit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.science), // Icon for Physics-Based Animations
            label: 'Physics',
          ),
        ],
        selectedItemColor:
            Colors.blueAccent, // Highlight color for selected tab
        unselectedItemColor: Colors.grey, // Color for unselected tabs
        showUnselectedLabels: true, // Show labels for unselected tabs
      ),
    );
  }
}
