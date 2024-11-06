// import 'package:cloud_firestore/cloud_firestore.dart';


// class DatabaseFunctions {
//   // Function to add a document
//   Future<void> addDocument() async {
//     try {
//       await FirebaseFirestore.instance.collection('testCollection').add({
//         'name': 'Test User',
//         'age': 25,
//       });
//       print("Document Added");
//     } catch (e) {
//       print("Failed to add document: $e");
//     }
//   }

//   // Function to read documents
//   Future<void> readDocuments() async {
//     try {
//       QuerySnapshot querySnapshot =
//           await FirebaseFirestore.instance.collection('testCollection').get();
//       for (var doc in querySnapshot.docs) {
//         print(doc.data());
//       }
//     } catch (e) {
//       print("Failed to read documents: $e");
//     }
//   }

//   // Function to update a document by ID
//   Future<void> updateDocument(String docId) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('testCollection')
//           .doc(docId)
//           .update({'age': 26});
//       print("Document Updated");
//     } catch (e) {
//       print("Failed to update document: $e");
//     }
//   }

//   // Function to delete a document by ID
//   Future<void> deleteDocument(String docId) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('testCollection')
//           .doc(docId)
//           .delete();
//       print("Document Deleted");
//     } catch (e) {
//       print("Failed to delete document: $e");
//     }
//   }
// }



// // CREATE:
// // // Adding a new document with a generated ID
// // FirebaseFirestore.instance.collection('your_collection').add({
// //   'field_name': 'value',
// //   'another_field': 'another_value',
// // });
// // // Setting data with a specific document ID
// // FirebaseFirestore.instance.collection('your_collection').doc('your_doc_id').set({
// //   'field_name': 'value',
// // });

// // // READ
// // // SINGLE DOCUMENT
// // FirebaseFirestore.instance.collection('your_collection').doc('your_doc_id').get().then((doc) {
// //   if (doc.exists) {
// //     print(doc.data());
// //   }
// // });
// // // ALL DOCUMENTS IN A SELECTION
// // FirebaseFirestore.instance.collection('your_collection').get().then((snapshot) {
// //   for (var doc in snapshot.docs) {
// //     print(doc.data());
// //   }
// // });
// // // QUERYING DOCUMENTS (e.g., filtering);
// // FirebaseFirestore.instance
// //   .collection('your_collection')
// //   .where('field_name', isEqualTo: 'value')
// //   .get()
// //   .then((snapshot) {
// //     for (var doc in snapshot.docs) {
// //       print(doc.data());
// //     }
// //   });

// // //UPDATE 
// // // Update specific fields in an existing document
// // FirebaseFirestore.instance.collection('your_collection').doc('your_doc_id').update({
// //   'field_name': 'new_value',
// // });

// // //DELETE
// // //DELETE DOCUMENT:
// // FirebaseFirestore.instance.collection('your_collection').doc('your_doc_id').delete();

// // //DELETE A FIELD IN THE DOCUMENT
// // FirebaseFirestore.instance.collection('your_collection').doc('your_doc_id').update({
// //   'field_name': FieldValue.delete(),
// // });


