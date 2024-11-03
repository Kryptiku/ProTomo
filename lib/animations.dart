import 'dart:math';
import 'package:flutter/material.dart';

class BobbingRotatingImage extends StatefulWidget {
  final String imagePath;
  final double bobbingDistance;
  final int bobbingDuration;
  final int rotationDuration;
  final double width;
  final double height;
  final bool clockwise; // New parameter to control rotation direction

  const BobbingRotatingImage({
    Key? key,
    required this.imagePath,
    this.bobbingDistance = 40.0,
    this.bobbingDuration = 2,
    this.rotationDuration = 10,
    this.width = 200,
    this.height = 200,
    this.clockwise = true, // Default to clockwise
  }) : super(key: key);

  @override
  State<BobbingRotatingImage> createState() => _BobbingRotatingImageState();
}

class _BobbingRotatingImageState extends State<BobbingRotatingImage> with TickerProviderStateMixin {
  late AnimationController _bobbingController;
  late AnimationController _rotationController;
  late Animation<double> _bobbingAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Bobbing animation controller
    _bobbingController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.bobbingDuration),
    )..repeat(reverse: true);

    _bobbingAnimation = Tween<double>(begin: 0, end: widget.bobbingDistance).animate(
      CurvedAnimation(parent: _bobbingController, curve: Curves.easeInOut),
    );

    // Continuous rotation animation controller
    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.rotationDuration),
    )..repeat();

    // Use the `clockwise` parameter to determine the direction of the rotation
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: widget.clockwise ? 2 * pi : -2 * pi, // Clockwise or counterclockwise
    ).animate(_rotationController);
  }

  @override
  void dispose() {
    _bobbingController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_bobbingAnimation, _rotationAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bobbingAnimation.value),
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: child,
          ),
        );
      },
      child: Image.asset(
        widget.imagePath,
        width: widget.width,
        height: widget.height,
      ),
    );
  }
}
