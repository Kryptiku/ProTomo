import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // Add user to Firestore
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'coins': 100,
          'creationTime': FieldValue.serverTimestamp(),
        });
        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Registration Failed"),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email Address"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter an email address";
                  } else if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(value)) {
                    return "Please enter a valid email address";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a password";
                  } else if (value.length < 6) {
                    return "Password should be at least 6 characters";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _register(context),
                child: Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
