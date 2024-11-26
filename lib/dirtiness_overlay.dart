import 'package:flutter/material.dart';

class DirtinessOverlay extends StatelessWidget {
  final int dirtinessLevel;
  final int maxDirtinessLevel;

  const DirtinessOverlay({
    Key? key,
    required this.dirtinessLevel,
    required this.maxDirtinessLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate opacity based on dirtiness level
    final opacity = (dirtinessLevel / maxDirtinessLevel) * 0.5; // Max opacity of 0.5

    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          color: Colors.brown.withOpacity(opacity),
        ),
      ),
    );
  }
}

