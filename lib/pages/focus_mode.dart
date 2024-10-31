import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(FocusMode());
}

class FocusMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Focus")),
        body: Center(child: RotatingKnob()),
      ),
    );
  }
}

class RotatingKnob extends StatefulWidget {
  @override
  _RotatingKnobState createState() => _RotatingKnobState();
}

class _RotatingKnobState extends State<RotatingKnob> {
  double angle = 0.0; // Angle in radians for tracking the small circle's position

  @override
  Widget build(BuildContext context) {
    double radius = 100.0; // Radius of the larger circle
    double orbitOffset = 30.0; // Extra space between the two circles

    // Calculate the position of the small circle with an added orbitOffset
    double smallCircleX = (radius + orbitOffset) * cos(angle);
    double smallCircleY = (radius + orbitOffset) * sin(angle);

    return GestureDetector(
      onPanUpdate: (details) {
        // Calculate the angle based on drag position
        Offset center = Offset(0, 0);
        Offset position = details.localPosition - Offset(radius, radius);
        setState(() {
          angle = atan2(position.dy, position.dx);
        });
      },
      child: Container(
        width: (radius + orbitOffset) * 2,
        height: (radius + orbitOffset) * 2,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Big circle
            Image.asset(
              'assets/big_bubble.png',
            // Container(
              width: radius * 2,
              height: radius * 2,),
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     color: Colors.blue[300],
            //   ),
            // ),
            // Small orbiting circle with extra space
            Transform.translate(
              offset: Offset(smallCircleX, smallCircleY),
              child: Image.asset(
                'assets/small_bubble.png',
                width: 40,
                height: 40,
              )
              // Container(
              //   width: 30,
              //   height: 30,
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: Colors.red,
              //   ),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
