import 'package:animation/screens/explict_animation.dart';
import 'package:animation/screens/implict_animation.dart';
import 'package:animation/screens/physics_based_animation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Animations')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildNavButton(
            context,
            'Implicit Animations',
            const ImplicitAnimationsScreen(),
          ),
          _buildNavButton(
            context,
            'Explicit Animations',
            const ExplicitAnimationScreen(),
          ),
          _buildNavButton(
            context,
            'Physics-Based Animations',
            const PhysicsAnimationScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String title, Widget screen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen),
            ),
        child: Text(title),
      ),
    );
  }
}
