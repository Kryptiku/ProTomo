import 'package:flutter/material.dart';
import 'package:protomo/pages/focus_mode.dart';
import 'package:protomo/pages/home.dart';
import 'package:protomo/pages/loading.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/home',
  routes: {
    '/': (context) => Loading(),
    '/home': (context) => Home(),
    '/focus': (context) => FocusMode(),
  },
));