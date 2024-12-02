import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Add provider import
import 'package:protomo/pages/history.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:protomo/pages/focus_mode.dart';
import 'package:protomo/pages/home.dart';
import 'package:protomo/pages/login.dart';
import 'package:protomo/pages/register.dart';
import 'package:protomo/pages/start.dart';
import 'pet_state.dart'; // Adjust the path to where your PetState class is located

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PetState()), // Provide PetState
      ],
      child: MaterialApp(
        initialRoute: '/start',
        routes: {
          '/home': (context) => Home(),
          '/focus': (context) => TimerKnob(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterScreen(),
          '/history': (context) => HistoryPage(),
          '/start': (context) => StartPage(),
        },
      ),
    ),
  );
}
