import 'package:flutter/material.dart';
import 'package:protomo/pages/audio_service.dart';
import 'package:protomo/pages/settings.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            // Background Image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/main_bg.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment(0.5, 0),
                ),
              ),
            ),
            // Centered Start Button
            Transform.translate(
              offset: Offset(50, -200), // Moves the image by x=20, y=-30
              child: Container(
                height: 1000,
                width: 1000,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/axolotl/Pink.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                  AudioService.playSoundFx();
                  AudioService.playBackgroundMusic();
                },

                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  backgroundColor: Colors.blue.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Start',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
