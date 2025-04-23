import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'dart:math' as math;

/// A screen that demonstrates advanced physics-based animations in Flutter.
/// 
/// This screen showcases various physics simulations including:
/// - Spring physics for bouncing effects
/// - Gravity simulation
/// - Drag physics for user interaction
/// - Multiple animated objects with different properties
class PhysicsAnimationScreen extends StatefulWidget {
  const PhysicsAnimationScreen({super.key});

  @override
  _PhysicsAnimationScreenState createState() => _PhysicsAnimationScreenState();
}

class _PhysicsAnimationScreenState extends State<PhysicsAnimationScreen>
    with TickerProviderStateMixin {
  // Main animation controller
  late AnimationController _mainController;
  
  // Secondary animation controller for independent animations
  late AnimationController _secondaryController;
  
  // Draggable animation controller
  late AnimationController _dragController;

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
  
  // List of particle positions for background effect
  final List<ParticleModel> _particles = [];
  
  // Physics simulation for draggable object
  Alignment _dragAlignment = Alignment.center;
  Animation<Alignment>? _springAnimation2;
  
  // User control values
  double _speedFactor = 1.0;
  double _bounceFactor = 1.0;
  bool _isPlaying = true;
  
  // Random generator for particle effects
  final math.Random _random = math.Random();

  /// Initialize animations and controllers
  @override
  void initState() {
    super.initState();

    // Initialize the main animation controller
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Initialize the secondary animation controller with different duration
    _secondaryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    
    // Initialize the drag controller for user interaction
    _dragController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Define the falling animation with improved physics
    _fallingAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 1),
    ).animate(CurvedAnimation(
      parent: _mainController, 
      curve: Curves.bounceOut,
    ));

    // Define the spring animation with more natural bounce
    _springAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _mainController, 
      curve: Curves.elasticOut,
    ));

    // Define the rotation animation
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _secondaryController, 
      curve: Curves.easeInOut,
    ));

    // Define the color animation with more vibrant colors
    _colorAnimation = ColorTween(
      begin: Colors.blue.shade400,
      end: Colors.purple.shade600,
    ).animate(CurvedAnimation(
      parent: _mainController, 
      curve: Curves.easeInOut,
    ));

    // Define the app bar color animation
    _appBarColorAnimation = ColorTween(
      begin: Colors.deepPurple.shade700,
      end: Colors.teal.shade600,
    ).animate(CurvedAnimation(
      parent: _secondaryController, 
      curve: Curves.easeInOut,
    ));

    // Generate background particles
    _generateParticles();

    // Start animations
    _mainController.repeat(reverse: true);
    _secondaryController.repeat(reverse: true);
    
    // Add listener to rebuild on animation changes
    _mainController.addListener(() => setState(() {}));
    _secondaryController.addListener(() => setState(() {}));
  }

  /// Generate random particles for background effect
  void _generateParticles() {
    for (int i = 0; i < 50; i++) {
      _particles.add(
        ParticleModel(
          position: Offset(
            _random.nextDouble() * 400 - 200,
            _random.nextDouble() * 400 - 200,
          ),
          color: Color.fromRGBO(
            _random.nextInt(255),
            _random.nextInt(255),
            _random.nextInt(255),
            _random.nextDouble() * 0.7 + 0.3,
          ),
          size: _random.nextDouble() * 15 + 5,
          speed: _random.nextDouble() * 2 + 0.5,
        ),
      );
    }
  }

  /// Run a spring simulation when the user stops dragging
  void _runSpringSimulation(Offset pixelsPerSecond, Size size) {
    // Calculate spring simulation parameters based on drag velocity
    _springAnimation2 = _dragController.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      ),
    );
    
    // Create a spring simulation with custom parameters
    final SpringDescription spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );
    
    final simulation = SpringSimulation(
      spring,
      0,
      1,
      -pixelsPerSecond.distance / (size.width * 0.5) * _bounceFactor,
    );
    
    // Run the simulation
    _dragController.animateWith(simulation);
  }

  /// Clean up resources when the widget is removed
  @override
  void dispose() {
    _mainController.dispose();
    _secondaryController.dispose();
    _dragController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Physics Animation'),
        backgroundColor: _appBarColorAnimation.value,
        actions: [
          // Play/pause button
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              setState(() {
                _isPlaying = !_isPlaying;
                if (_isPlaying) {
                  _mainController.repeat(reverse: true);
                  _secondaryController.repeat(reverse: true);
                } else {
                  _mainController.stop();
                  _secondaryController.stop();
                }
              });
            },
          ),
          // Reset button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _mainController.reset();
                _secondaryController.reset();
                _dragAlignment = Alignment.center;
                if (_isPlaying) {
                  _mainController.repeat(reverse: true);
                  _secondaryController.repeat(reverse: true);
                }
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background particles
          ...List.generate(_particles.length, (index) {
            final particle = _particles[index];
            return Positioned(
              left: size.width / 2 + particle.position.dx + 
                  math.sin(_mainController.value * math.pi * particle.speed) * 20,
              top: size.height / 2 + particle.position.dy + 
                  math.cos(_secondaryController.value * math.pi * particle.speed) * 20,
              child: Opacity(
                opacity: 0.6 + _mainController.value * 0.4,
                child: Container(
                  width: particle.size,
                  height: particle.size,
                  decoration: BoxDecoration(
                    color: particle.color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: particle.color.withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          
          // Main animated object
          Center(
            child: Transform.translate(
              offset: _fallingAnimation.value * 200 * _speedFactor,
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: Transform.scale(
                  scale: _springAnimation.value * _bounceFactor,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          _colorAnimation.value!.withOpacity(0.8),
                          _colorAnimation.value!,
                        ],
                        center: Alignment.topLeft,
                        radius: 1.0,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (_colorAnimation.value ?? Colors.purple).withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 5,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.flutter_dash,
                        color: Colors.white.withOpacity(0.9),
                        size: 50,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Draggable object with physics
          Align(
            alignment: _springAnimation2?.value ?? _dragAlignment,
            child: GestureDetector(
              onPanDown: (details) {
                _dragController.stop();
              },
              onPanUpdate: (details) {
                setState(() {
                  _dragAlignment += Alignment(
                    details.delta.dx / (size.width / 2),
                    details.delta.dy / (size.height / 2),
                  );
                });
              },
              onPanEnd: (details) {
                _runSpringSimulation(
                  details.velocity.pixelsPerSecond,
                  size,
                );
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: SweepGradient(
                    colors: [
                      Colors.amber,
                      Colors.red,
                      Colors.purple,
                      Colors.blue,
                      Colors.amber,
                    ],
                    stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'DRAG',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // Control panel for animation parameters
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.black12,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Speed control slider
            Row(
              children: [
                const Text('Speed:'),
                Expanded(
                  child: Slider(
                    value: _speedFactor,
                    min: 0.1,
                    max: 2.0,
                    divisions: 19,
                    label: _speedFactor.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        _speedFactor = value;
                        _mainController.duration = Duration(
                          milliseconds: (2000 / _speedFactor).round(),
                        );
                        if (_isPlaying) {
                          _mainController.repeat(reverse: true);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            // Bounce factor slider
            Row(
              children: [
                const Text('Bounce:'),
                Expanded(
                  child: Slider(
                    value: _bounceFactor,
                    min: 0.5,
                    max: 2.0,
                    divisions: 15,
                    label: _bounceFactor.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        _bounceFactor = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Model class for background particle effects
class ParticleModel {
  final Offset position;
  final Color color;
  final double size;
  final double speed;

  ParticleModel({
    required this.position,
    required this.color,
    required this.size,
    required this.speed,
  });
}
