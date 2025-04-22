import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'dart:math';

class PhysicsAnimationScreen extends StatefulWidget {
  const PhysicsAnimationScreen({super.key});

  @override
  _PhysicsAnimationScreenState createState() => _PhysicsAnimationScreenState();
}

class _PhysicsAnimationScreenState extends State<PhysicsAnimationScreen>
    with SingleTickerProviderStateMixin {
  // Animation controller to handle animation timing
  late AnimationController _controller;

  // Animation for simulating falling (gravity effect)
  late Animation<Offset> _fallingAnimation;

  // Animation for simulating a spring (bouncing effect)
  late Animation<double> _springAnimation;

  // Rotation animation to make the object spin
  late Animation<double> _rotationAnimation;

  // Color animation to dynamically change the object's color
  late Animation<Color?> _colorAnimation;

  // App bar color animation to change color dynamically
  late Animation<Color?> _appBarColorAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller with a 2-second duration
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Define the falling animation to simulate gravity
    _fallingAnimation = Tween<Offset>(
      begin: const Offset(0, -1), // Start from the top
      end: const Offset(0, 1), // Move towards the bottom
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));

    // Define the spring animation to simulate a bounce effect
    _springAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    // Define the rotation animation for a spinning effect
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Define the color animation for the object
    _colorAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.purple,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Define the app bar color animation
    _appBarColorAnimation = ColorTween(
      begin: Colors.deepOrange,
      end: Colors.teal,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Repeat the animation in reverse to create a continuous effect
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    // Dispose of the animation controller to free up resources
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Advanced Physics Animation'),
            backgroundColor:
                _appBarColorAnimation.value, // Dynamic app bar color change
          ),
          body: Center(
            child: Transform.translate(
              offset: _fallingAnimation.value * 200, // Apply falling motion
              child: Transform.rotate(
                angle: _rotationAnimation.value, // Apply spinning effect
                child: Transform.scale(
                  scale: _springAnimation.value, // Apply bounce effect
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: _colorAnimation.value, // Dynamic color change
                      shape: BoxShape.circle, // Create a circular object
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 3,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
