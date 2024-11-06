import 'package:flutter/material.dart';
import 'package:protomo/database_functions.dart';

class Home extends StatelessWidget {
  final DatabaseFunctions dbFunctions =
      DatabaseFunctions(); // Instantiate your database functions

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: dbFunctions.addDocument,
              child: Text('Add Document'),
            ),
            ElevatedButton(
              onPressed: dbFunctions.readDocuments,
              child: Text('Read Documents'),
            ),
            // Similarly, add buttons for updateDocument and deleteDocument if needed
          ],
        ),
      ),
    );
  }
}
