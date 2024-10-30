import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/main_bg.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment(0.5, 0)
                )
              ),
            ),
            Center(
                child: SpinKitFadingCube(
                  color: Colors.deepPurple,
                  size: 100.0,
                ),
            ),
          ],
        ),
      ),
    );
  }
}
