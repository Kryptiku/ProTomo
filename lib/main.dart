import 'package:flutter/material.dart';
import 'package:protomo/dbtest.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:protomo/pages/focus_mode.dart';
import 'package:protomo/pages/home.dart';
import 'package:protomo/pages/loading.dart';
import 'package:protomo/pages/login.dart';
import 'package:protomo/pages/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/': (context) => Loading(),
      '/home': (context) => Home(),
      '/focus': (context) => TimerKnob(),
      '/login': (context) => LoginPage(),
      '/register': (context) => RegisterScreen(),
    },
  ));
}
