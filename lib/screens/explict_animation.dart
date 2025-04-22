import 'package:flutter/material.dart';
import 'dart:math';

class ExplicitAnimationScreen extends StatefulWidget {
  const ExplicitAnimationScreen({super.key});

  @override
  _ExplicitAnimationScreenState createState() =>
      _ExplicitAnimationScreenState();
}

class _ExplicitAnimationScreenState extends State<ExplicitAnimationScreen>
    with SingleTickerProviderStateMixin {
  // Animation controller to handle animation timing
  late AnimationController _controller;

  // Scale animation to increase and decrease the size of the widget
  late Animation<double> _scaleAnimation;

  // Rotation animation to rotate the widget
  late Animation<double> _rotationAnimation;

  // Color animation to change the color of the animated widget
  late Animation<Color?> _colorAnimation;

  // App bar color animation to change its color dynamically
  late Animation<Color?> _appBarColorAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Animation duration
      vsync: this,
    )..repeat(reverse: true); // Makes the animation repeat in reverse

    // Define the scale animation (shrinking and expanding effect)
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Define the rotation animation (spinning effect)
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: pi * 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Define the color animation for the widget
    _colorAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.purple,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Define the app bar color animation
    _appBarColorAnimation = ColorTween(
      begin: Colors.deepOrange,
      end: Colors.teal,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Dispose of the animation controller when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Advanced Explicit Animation'),
            backgroundColor:
                _appBarColorAnimation.value, // Dynamically change app bar color
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2), // Push the animated object up
              Center(
                child: Transform.rotate(
                  angle: _rotationAnimation.value, // Apply rotation animation
                  child: Transform.scale(
                    scale: _scaleAnimation.value, // Apply scale animation
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color:
                            _colorAnimation
                                .value, // Change background color dynamically
                        borderRadius: BorderRadius.circular(
                          15,
                        ), // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 3,
                            offset: Offset(3, 3),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Animating',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 3), // Maintain spacing below
            ],
          ),
        );
      },
    );
  }
}
