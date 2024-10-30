import 'package:flutter/material.dart';

void main() => runApp(const Home());

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: false,
          bottom: false,
          child: Container(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/main_bg.png"),
                      fit: BoxFit.cover,
                      alignment: Alignment(-0.4, 0),
                    ),
                  ),
                ),
                Center(
                  child: Image.asset(
                    "assets/axolotl/Pink.png",
                    width: 200,
                    height: 200,
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 60.0,
                            height: 60.0,
                            child: Image.asset(
                              'assets/buttons/calendar.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              print('Start Timer');
                              Navigator.pushNamed(context, '/focus');
                            },
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: Image.asset(
                                'assets/buttons/start.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 70,
                            height: 70,
                            child: Image.asset(
                              'assets/buttons/history.png',
                            ),
                          )
                        ],
                      )
                    ]
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: Image.asset(
                                'assets/buttons/settings.png',
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: Image.asset(
                                'assets/buttons/settings.png',
                              ),
                            ),
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: Image.asset(
                                'assets/buttons/settings.png',
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
      ),
    );
  }
}
