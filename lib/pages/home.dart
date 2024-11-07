import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:protomo/pages/audio_service.dart';
import 'package:protomo/pages/closet.dart';
import 'package:protomo/animations.dart';
import 'package:protomo/pages/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlameAudio.audioCache
      .loadAll(['sample_bg_music.mp3', 'sample_sound_fx.mp3']);
  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  // void initState() {
  //   super.initState();
  //   _playBackgroundMusic();
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: false,
          bottom: false,
          child: GestureDetector(
            onTap: () {
              AudioService.playSoundFx();
            },
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
                      child: BobbingRotatingImage(
                    imagePath: "assets/axolotl/Pink.png",
                    bobbingDistance: 40.0,
                    bobbingDuration: 5,
                    rotationDuration: 50,
                    width: 200,
                    height: 200,
                  )),
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
                                  AudioService.playSoundFx();
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
                        ]),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showSettings(context);
                                  AudioService.playSoundFx();
                                },
                                child: SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: Image.asset(
                                    'assets/buttons/settings.png',
                                  ),
                                ),
                              )
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
                              Image.asset(
                                'assets/buttons/coin.png',
                                height: 45,
                                fit: BoxFit.contain,
                              ),
                              GestureDetector(
                                onTap: () {
                                  AudioService.playBackgroundMusic();
                                },
                                child: SizedBox(
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    showClosetShop(context);
                                    AudioService.playSoundFx();
                                  },
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Image.asset(
                                      'assets/buttons/briefcase.png',
                                    ),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
