import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreTest {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> testAddData() async {

      // Define the collection and data
      String collectionName = 'burat';
      String documentName = 'kupal';
      final city = <String, String>{
        "name": "Los Angeles",
        "state": "CA",
        "country": "USA"
      };

      try {
      // Add the document to the specified collection
      db.collection(collectionName).doc(documentName).set(city);
      print("Document added successfully!");
    } catch (e) {
      print("Error adding document: $e");
    }
  }
} // class
