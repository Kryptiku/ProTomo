import 'package:flutter/material.dart';
import 'package:protomo/pages/focus_mode.dart';
import 'package:protomo/pages/home.dart';
import 'package:protomo/pages/loading.dart';
import 'package:protomo/pages/login.dart';
import 'package:protomo/pages/register.dart';

void main() => runApp(MaterialApp(
      initialRoute: '/login',
      routes: {
        '/': (context) => const Loading(),
        '/home': (context) => const Home(),
        '/focus': (context) => const TimerKnob(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterScreen()
      },
    ));
