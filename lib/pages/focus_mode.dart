import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(FocusMode());
}

class FocusMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DialPage(),
    );
  }
}

class DialPage extends StatefulWidget {
  @override
  _DialPageState createState() => _DialPageState();
}

class _DialPageState extends State<DialPage> {
  double rotation = 0.0; // Rotation angle in radians

  Offset center = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arc Motion Dial'),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate the center of the dial
            center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);

            return GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  // Calculate the angle between the center and the drag position
                  final touchPosition = details.localPosition;
                  rotation = _calculateAngle(center, touchPosition);
                });
              },
              child: Transform.rotate(
                angle: rotation,
                child: Image.asset(
                  'assets/dial.png', // Replace with your image path
                  width: 200,
                  height: 200,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  double _calculateAngle(Offset center, Offset touchPosition) {
    // Calculate the delta between the center and touch
    final dx = touchPosition.dx - center.dx;
    final dy = touchPosition.dy - center.dy;

    // Calculate the angle with atan2, which gives the angle in radians
    return atan2(dy, dx);
  }
}
