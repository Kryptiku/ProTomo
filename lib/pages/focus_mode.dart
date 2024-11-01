// Fully Layout Focus Mode
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(FocusMode());
}

class FocusMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Timer Knob")),
        body: Center(child: TimerKnob()),
      ),
    );
  }
}

class TimerKnob extends StatefulWidget {
  @override
  _TimerKnobState createState() => _TimerKnobState();
}

class _TimerKnobState extends State<TimerKnob> {
  double angle = -pi / 2; // Start angle at the top for 0 minutes
  int timerValue = 0; // Timer value in minutes
  int countdownSeconds = 0; // Total countdown seconds
  Timer? countdownTimer; // Timer instance for countdown
  bool isCountingDown = false; // Flag to check if countdown is active

  final int maxMinutes = 180; // Maximum timer value
  final int increment = 5; // Timer increments in minutes

  @override
  Widget build(BuildContext context) {
    double radius = 100.0; // Radius of the larger circle
    double orbitOffset = 30.0; // Extra space between the two circles

    // Calculate the position of the small circle with an added orbitOffset
    double smallCircleX = (radius + orbitOffset) * cos(angle);
    double smallCircleY = (radius + orbitOffset) * sin(angle);

    // Format time in minutes:seconds
    String formattedTime = '${(countdownSeconds ~/ 60).toString().padLeft(2, '0')}:${(countdownSeconds % 60).toString().padLeft(2, '0')}';

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Display timer countdown
        Text(
          isCountingDown ? formattedTime : '$timerValue min',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        GestureDetector(
          onPanUpdate: (details) {
            if (isCountingDown) return; // Prevent adjustment during countdown

            // Calculate the angle based on drag position
            Offset position = details.localPosition - Offset(radius, radius);
            double newAngle = atan2(position.dy, position.dx);

            // Normalize angle to [0, 2π] and clamp to valid range
            if (newAngle < -pi / 2) {
              newAngle += 2 * pi;
            }

            // Calculate new timer value based on the new angle
            double normalizedAngle = (newAngle + pi / 2) / (2 * pi); // Adjust for top start
            int newTimerValue = (normalizedAngle * maxMinutes).round();

            // Ensure timer value respects the increment, max limit, and does not go below 0
            // Fix minor bug with small bubble being able to rotate more than 360 degrees
            timerValue = (newTimerValue ~/ increment) * increment;
            // timerValue = timerValue.clamp(0, maxMinutes);

            // Set the angle for the small circle
            angle = (timerValue / maxMinutes.toDouble()) * (2 * pi) - (pi / 2); // Adjust angle based on timer value

            // Update the state to reflect the changes
            setState(() {});
          },
          child: Container(
            width: (radius + orbitOffset) * 2,
            height: (radius + orbitOffset) * 2,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Big circle with custom image
                Image.asset(
                  'assets/big_bubble.png', // Path to your larger PNG image
                  width: radius * 2,
                  height: radius * 2,
                ),
                // Small orbiting circle with custom image
                Transform.translate(
                  offset: Offset(smallCircleX, smallCircleY),
                  child: Image.asset(
                    'assets/small_bubble.png', // Path to your smaller PNG image
                    width: 30,
                    height: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        // Start Timer button
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: isCountingDown ? null : startTimer,
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: Image.asset(
                        'assets/buttons/start.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  void startTimer() {
    setState(() {
      countdownSeconds = timerValue * 60; // Convert to seconds
      isCountingDown = true; // Start the countdown
    });

    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (countdownSeconds > 0) {
          countdownSeconds--;
        } else {
          countdownTimer?.cancel();
          isCountingDown = false; // Stop countdown when time runs out
        }
      });
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }
}
