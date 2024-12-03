import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:protomo/pages/home.dart';
import 'package:protomo/pages/register.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void loginButton(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: Colors.black54,
          title: const Text(
            "Login Failed",
            style: TextStyle(
              fontFamily: 'VT323',
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          content: Text(
            e.toString(),
            style: const TextStyle(
              fontFamily: 'VT323',
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "OK",
                style: TextStyle(
                  fontFamily: 'VT323',
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(
            fontFamily: 'VT323',
            fontSize: 28,
          ),
        ),
        backgroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App Title
              const Text(
                "Welcome to PROTOMO!",
                style: TextStyle(
                  fontFamily: 'VT323',
                  fontSize: 32,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Email TextField
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(
                    fontFamily: 'VT323',
                    fontSize: 20,
                    color: Colors.white70,
                  ),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password TextField
              TextField(
                controller: passwordController,
                obscureText: true,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(
                    fontFamily: 'VT323',
                    fontSize: 20,
                    color: Colors.white70,
                  ),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Login Button
              ElevatedButton(
                onPressed: () => loginButton(context),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontFamily: 'VT323',
                    fontSize: 22,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Register Prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(
                      fontFamily: 'VT323',
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        fontFamily: 'VT323',
                        fontSize: 18,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
