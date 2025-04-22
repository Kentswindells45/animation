import 'package:flutter/material.dart';
import 'dart:math';

class ImplicitAnimationsScreen extends StatefulWidget {
  const ImplicitAnimationsScreen({super.key});

  @override
  _ImplicitAnimationsScreenState createState() =>
      _ImplicitAnimationsScreenState();
}

class _ImplicitAnimationsScreenState extends State<ImplicitAnimationsScreen> {
  bool _isExpanded = false;
  List<Color> _colors = [Colors.red, Colors.orange];
  double _fontSize = 18;
  double _letterSpacing = 1.0;
  double _opacity = 1.0;
  double _rotation = 0.0;
  double _scale = 1.0;
  Color _textColor = Colors.white;
  Color _appBarColor = Colors.deepPurple;

  void _changeColors() {
    final random = Random();
    setState(() {
      _colors = [
        Color.fromRGBO(
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
          1,
        ),
        Color.fromRGBO(
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
          1,
        ),
      ];
      _appBarColor = Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1,
      );
      _isExpanded = !_isExpanded;
      _fontSize = _isExpanded ? 28 : 18;
      _letterSpacing = _isExpanded ? 5.0 : 1.0;
      _opacity = _isExpanded ? 0.7 : 1.0;
      _rotation = _isExpanded ? 0.5 : 0.0;
      _scale = _isExpanded ? 1.3 : 1.0;
      _textColor =
          _colors[0].computeLuminance() > 0.5 ? Colors.black : Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fancy Implicit Animations',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: _appBarColor,
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _changeColors,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.elasticOut,
                  width: _isExpanded ? 220 : 120,
                  height: _isExpanded ? 220 : 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _colors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(_isExpanded ? 50 : 10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: _isExpanded ? 25 : 8,
                        spreadRadius: _isExpanded ? 10 : 3,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 800),
                        top: _isExpanded ? 15 : 50,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 600),
                          opacity: _opacity,
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 600),
                            style: TextStyle(
                              fontSize: _fontSize,
                              fontWeight: FontWeight.bold,
                              letterSpacing: _letterSpacing,
                              color: _textColor,
                              shadows: [
                                Shadow(
                                  blurRadius: _isExpanded ? 15 : 4,
                                  color: Colors.black54,
                                  offset: const Offset(3, 3),
                                ),
                              ],
                            ),
                            child: AnimatedScale(
                              duration: const Duration(milliseconds: 600),
                              scale: _scale,
                              child: AnimatedRotation(
                                duration: const Duration(milliseconds: 600),
                                turns: _rotation,
                                child: const Text('Tap Me!'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _changeColors,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  shadowColor: Colors.black.withOpacity(0.4),
                  elevation: 10,
                ),
                child: const Text(
                  'Animate',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
