import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:protomo/pages/focus_mode.dart';
import 'package:protomo/pages/home.dart';
import 'package:protomo/pages/login.dart';
import 'package:protomo/pages/register.dart';
import 'package:protomo/pages/start.dart';
import 'pet_state.dart';
import 'skin_state.dart'; // Import the new SkinState class

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PetState()),
        ChangeNotifierProvider(create: (context) => SkinState()), // Add SkinState provider
      ],
      child: MaterialApp(
        home: AuthCheck(),
        routes: {
          '/start': (context) => StartPage(),
          '/home': (context) => Home(),
          '/focus': (context) => TimerKnob(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterScreen(),
        },
      ),
    ),
  );
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return StartPage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
