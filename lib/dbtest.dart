import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

class FirestoreTest {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  void testConnection() async {
    try {
      final testDoc = await db.collection("testConnection").doc("testDoc").get();
      if (testDoc.exists) {
        print("Firestore connection is working! Document data: ${testDoc.data()}");
      } else {
        print("No document found. Writing new test document.");
        await db.collection("testConnection").doc("testDoc").set({"testField": "testValue"});
        print("Test document written successfully!");
      }
    } catch (e) {
      print("Error connecting to Firestore: $e");
    }
  }

  void testAddData() {
    final city = <String, String>{
      "name": "Los Angeles",
      "state": "CA",
      "country": "USA"
    };

    db
        .collection("cities")
        .doc("LA")
        .set(city)
        .onError((e, _) => print("Error writing document: $e"));
  }
}
