// Fully Layout Focus Mode
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:protomo/animations.dart';
import 'package:flutter/services.dart';
import 'package:protomo/pages/audio_service.dart';
import 'package:protomo/database_functions.dart';

String loggedUserID = db.getCurrentUserId().toString();
final db = FirestoreService();

void main() {
  runApp(const TimerKnob());
}

class TimerKnob extends StatefulWidget {
  const TimerKnob({super.key});

  @override
  State<TimerKnob> createState() => _TimerKnobState();
}

class _TimerKnobState extends State<TimerKnob> with TickerProviderStateMixin{
  //Screen Pinning
  static const platform = MethodChannel('com.example.your_app/screen_pin');

  Future<void> startScreenPinning() async {
    try {
      await platform.invokeMethod('startScreenPinning');
    } on PlatformException catch (e) {
      print("Failed to start screen pinning: '${e.message}'.");
    }
  }

  Future<void> stopScreenPinning() async {
    try {
      await platform.invokeMethod('stopScreenPinning');
    } on PlatformException catch (e) {
      print("Failed to stop screen pinning: '${e.message}'.");
    }
  }

  double angle = -pi / 2; // Start angle at the top for 0 minutes
  int timerValue = 0; // Timer value in minutes
  int countdownSeconds = 0; // Total countdown seconds
  Timer? countdownTimer; // Timer instance for countdown
  bool isCountingDown = false; // Flag to check if countdown is active
  String buttonState = 'focusStart.png';
  bool buttonVisibility = true;

  final int maxMinutes = 180; // Maximum timer value
  final int increment = 5; // Timer increments in minutes

  // Coin Params
  int coinsAwarded = 0;
  final List<CoinAnimation> _animations = [];

  void _showCoinAnimation() {
    AudioService.coinFx();
    final random = Random();
    final startX = MediaQuery.of(context).size.width / 2 + random.nextDouble() * 40 - 20;
    final endX = startX + random.nextDouble() * 80 - 40;

    final controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    final animation = CoinAnimation(
      controller: controller,
      startX: startX,
      endX: endX,
    );

    setState(() {
      _animations.add(animation);
    });

    controller.forward().then((_) {
      setState(() {
        _animations.remove(animation);
      });
      controller.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    double radius = 100.0; // Radius of the larger circle
    double orbitOffset = 60.0; // Extra space between the two circles

    // Calculate the position of the small circle with an added orbitOffset
    double smallCircleX = (radius + orbitOffset) * cos(angle);
    double smallCircleY = (radius + orbitOffset) * sin(angle);

    // Format time in minutes:seconds
    String formattedTime =
        '${(countdownSeconds ~/ 60).toString().padLeft(2, '0')}:${(countdownSeconds % 60).toString().padLeft(2, '0')}';

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/main_bg.png",),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Stack(
                children: [
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

                      coinsAwarded = calculateCoins(timerValue);
                      // Update the state to reflect the changes
                      setState(() {});
                    },
                    child: Container(
                      width: (radius + orbitOffset) * 3,
                      height: (radius + orbitOffset) * 3,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          BobbingRotatingImage(
                            imagePath: 'assets/axolotl/pinkfloating.png',
                            bobbingDistance: 20.0,
                            bobbingDuration: 7,
                            rotationDuration: 50,
                            width: 200,
                            height: 200,
                          ),
                          Opacity(
                            opacity: 0.6,
                            child: BobbingRotatingImage(
                              imagePath: 'assets/big_bubble.png',
                              width: radius * 3,
                              height: radius * 3,
                              bobbingDistance: 20,
                              bobbingDuration: 6,
                              rotationDuration: 200,
                              clockwise: false,
                            ),
                            // child: Image.asset(
                            //   'assets/big_bubble.png', // Path to your larger PNG image
                            //   width: radius * 3,
                            //   height: radius * 3,
                            // ),
                          ),


                          // Small orbiting circle with custom image
                          Transform.translate(
                            offset: Offset(smallCircleX, smallCircleY),
                            child: Image.asset(
                              'assets/small_bubble.png', // Path to your smaller PNG image
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 100),
                SizedBox(height: 20),
                // Start Timer button
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '+$coinsAwarded',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 5,
                            ),
                          Image.asset(
                            'assets/buttons/coin.png',
                            width: 44,
                            height: 44,
                          ),
                        ],
                      ),
                      // Display timer countdown
                      Text(
                        isCountingDown ? formattedTime : '$timerValue:00',
                        style: TextStyle(
                          fontSize: 100,
                          fontFamily: "VT323",
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: isCountingDown ? stopTimer : startTimer,
                            child: Image.asset(
                              'assets/buttons/$buttonState',
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,)
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 50.0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (buttonVisibility)
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.asset(
                              'assets/buttons/exit.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      if (!buttonVisibility)
                        GestureDetector(
                          onTap: (){
                            print('musica');
                          },
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: Image.asset(
                              'assets/buttons/music_enabled.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            ..._animations
                .map((animation) => AnimatedBuilder(
              animation: animation.controller,
              builder: (context, child) {
                final value = animation.controller.value;
                final yOffset = 100 * value;
                final xOffset =
                    (animation.endX - animation.startX) *
                        sin(value * pi);
                return Positioned(
                  left: animation.startX + xOffset,
                  bottom:
                  MediaQuery.of(context).size.height / 2 +
                      25 +
                      yOffset,
                  child: Opacity(
                    opacity: 1 - value,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/buttons/coin.png',
                          width: 50,
                          height: 50,
                        ),
                        Text(
                          '+$coinsAwarded',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.orange,
                            fontFamily: 'VT323',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ))
                .toList(),
          ],
        ),
      ),
    );
  }



  int calculateCoins(int minutes) {
    return (minutes ~/5) * 3 ;
  }

  void startTimer() {
    AudioService.startFocusFx();
    if (timerValue == 0) {
      // Show snackbar when trying to start with zero time
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Please set the timer value before starting!",
            style: TextStyle(fontSize: 16),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(10),
        ),
      );
      return;
    }
    else {
      setState(() {
        buttonVisibility = false;
      });
    }

    startScreenPinning();
    setState(() {
      buttonState = 'stop.png';
      countdownSeconds = timerValue * 60; // Convert to seconds
      isCountingDown = true; // Start the countdown
    });

    int duration = countdownSeconds;

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (countdownSeconds > 0) {
          countdownSeconds--;
        } else {
          countdownTimer?.cancel();
          isCountingDown = false; // Stop countdown when time runs out
          buttonState = 'start.png';
          db.rewardUserDB(loggedUserID, coinsAwarded);
          db.addCompletedFocusToDB(loggedUserID, duration);
          stopScreenPinning();
          buttonVisibility = true;
          _showCoinAnimation();
          AudioService.coinFx();
        }
      });
    });
  }


  void stopTimer() {
    AudioService.stopTimeFx();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            height: 250, // Height of the dialog
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Even spacing between elements
              children: [
                // Title
                const Text(
                  "Stop Focus Mode?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    fontFamily: 'VT323',
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Description
                const Text(
                  "Are you sure you want to stop focus mode?",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'VT323',
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        side: const BorderSide(color: Colors.white, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        AudioService.popupNoFx();
                        Navigator.of(context).pop(); // Close dialog
                      },
                      child: const Text(
                        "No",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'VT323',
                          fontSize: 26,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        AudioService.popupYesFx();
                        timerStopped();
                        Navigator.of(context).pop();
                        // Add "Yes" functionality here
                      },
                      child: const Text(
                        "Yes",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'VT323',
                          fontSize: 26,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

void timerStopped() {
    stopScreenPinning();
    setState(() {
      isCountingDown = false;
      buttonState = 'focusStart.png';
      countdownTimer?.cancel();
      timerValue = 0;
      angle = -pi / 2;
      buttonVisibility = true;
    });

  }



  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }
}

class CoinAnimation {
  final AnimationController controller;
  final double startX;
  final double endX;

  CoinAnimation(
      {required this.controller, required this.startX, required this.endX});
}