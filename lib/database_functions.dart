import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> buyItem(String userID, String foodId) async {
    try {
      // Get the item document from the store collection
      final storeItemDoc = db.collection('store').doc(foodId);
      final DocumentSnapshot storeSnapshot = await storeItemDoc.get();

      if (storeSnapshot.exists) {
        // Retrieve the item's data
        final Map<String, dynamic> itemData = storeSnapshot.data() as Map<String, dynamic>;
        final int cost = itemData['cost'];

        // Reference the user's document
        final userDoc = db.collection('users').doc(userID);
        final DocumentSnapshot userSnapshot = await userDoc.get();

        if (userSnapshot.exists) {
          // Retrieve user's current coins
          final Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
          final int currentCoins = userData['coins'];

          if (currentCoins >= cost) {
            // Deduct cost from user's coins
            final int updatedCoins = currentCoins - cost;

            // Update user's coins in Firestore
            await userDoc.update({'coins': updatedCoins});

            // Add the item to the user's inventory
            final userInventoryDoc = userDoc.collection('inventory').doc(foodId);
            final bool itemExists = (await userInventoryDoc.get()).exists;

            if (itemExists) {
              await userInventoryDoc.update({'quantity': FieldValue.increment(1)});
            } else {
              // Copy all fields from the store item and add 'quantity'
              final Map<String, dynamic> newItemData = Map<String, dynamic>.from(itemData);
              newItemData['quantity'] = 1; // Add quantity field for the user's inventory
              await userInventoryDoc.set(newItemData);
            }

            print("Item bought successfully!");
          } else {
            print("Not enough coins to buy this item!");
          }
        } else {
          print("User document not found!");
        }
      } else {
        print("Item document not found!");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }


  Future<int> getUserCoins(String userID) async {
    return db.collection('users').doc(userID).snapshots().map((snapshot) => snapshot['coins'] as int).first; // Gets the first value from the stream
  }
  Stream<String> showCoins(String userID) {
    return db.collection('users').doc(userID).snapshots().map((snapshot) => snapshot['coins'].toString());
  }

  Future<String> getItemCost(String foodID) async {
    final doc = await db.collection('store').doc(foodID).get();
    return doc['cost'].toString();
  }

  Future<void> addTaskDb(String userID, String taskName) async {
    try {
      // Prepare the task data
      final data = <String, dynamic>{
        "dateEntered": DateTime.now(),
        "taskName": taskName,
      };

      // Add the task to the user's task collection
      await db.collection('users').doc(userID).collection('tasks').doc(taskName).set(data);
    } catch (e) {
      print("Error adding task '$taskName': $e");
    }
  }

  Future<void> finishTaskDb(String userID, String taskName) async {
    try {
      // Fetch the number of completed tasks
      var querySnapshot = await db.collection('users').doc(userID).collection('completedTasks').get();
      int taskNum = querySnapshot.docs.length; //get amount of tasks

      // Generate a new task number and name
      int newTaskNum = taskNum + 1;
      String newTaskName = newTaskNum.toString();

      final data = <String, dynamic>{
        "dateCompleted": DateTime.now(),
        "taskName": taskName,
      };

      await db.collection('users').doc(userID).collection('completedTasks').doc(newTaskName).set(data);
      await db.collection('users').doc(userID).collection('tasks').doc(taskName).delete();

    } catch (e) {
      print("Error completing task '$taskName': $e");
    }
  }

  Future<List<String>> getCompletedTasksDB(String userID) async {
    final completedTaskRef = db.collection('users').doc(userID).collection('completedTasks');

    try {
      // Fetch documents from Firestore, ordered by the 'dateCompleted' field
      final querySnapshot = await completedTaskRef
          .orderBy('dateCompleted', descending: true) // Order by 'dateCompleted' field in descending order
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No documents found in 'completedTasks'");
        return [];
      }

      // Extract the 'taskName' field from each document
      List<String> completedTaskNames = querySnapshot.docs
          .where((doc) => int.tryParse(doc.id) != null) // Ensure document ID is a number (optional check)
          .map((doc) => doc.data()['taskName'] as String) // Extract the 'taskName' field
          .toList();

      return completedTaskNames;
    } catch (e, stackTrace) {
      print("Error fetching completed tasks: $e");
      print(stackTrace);
      return [];
    }
  }


  Future<List<String>> getTasksDB(String userID) async {
    final completedTaskRef = db.collection('users').doc(userID).collection('tasks');

    try {
      // Fetch the tasks from Firestore
      final querySnapshot = await completedTaskRef.get();
      print("Fetched ${querySnapshot.docs.length} tasks");

      if (querySnapshot.docs.isEmpty) {
        print("No tasks found in 'tasks'");
        return [];
      }

      // Extract task names from the documents
      List<String> taskNames = querySnapshot.docs
          .map((doc) => doc['taskName'] as String)
          .toList();

      print("Task names: $taskNames");
      return taskNames;
    } catch (e, stackTrace) {
      print("Error fetching tasks: $e");
      print(stackTrace);
      return [];
    }
  }

  Future<int> getTasksAmountDB(String userID) async {
    final usertaskRef = db.collection('users').doc(userID).collection('tasks');
    final querySnapshot = await usertaskRef.get();

    return querySnapshot.docs.length;
  }

  Future<int> getCompletedTasksTodayDB(String userID) async {
    final completedTaskRef = db.collection('users').doc(userID).collection('completedTasks');
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    try {
      // Query tasks completed today
      QuerySnapshot querySnapshot = await completedTaskRef
          .where('dateCompleted', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('dateCompleted', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get();

      // Return the count of documents
      return querySnapshot.docs.length.toInt();
    } catch (e) {
      print("Error fetching completed tasks: $e");
      return 0;
    }
  }

  Future<int> getActiveTasksTodayDB(String userID) async {
    final completedTaskRef = db.collection('users').doc(userID).collection('tasks');
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    try {
      // Query tasks completed today
      QuerySnapshot querySnapshot = await completedTaskRef
          .where('dateEntered', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('dateEntered', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get();

      // Return the count of documents
      return querySnapshot.docs.length.toInt();
    } catch (e) {
      print("Error fetching completed tasks: $e");
      return 0;
    }
  }

  Future<void> rewardUserDB(String userID, int reward) async {
    final userRef = db.collection('users').doc(userID);
    final DocumentSnapshot userSnapshot = await userRef.get();

    final Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    final int currentCoins = userData['coins'];

    final int updatedCoins = currentCoins + reward;

    await userRef.update({'coins': updatedCoins});
  }

  Stream<List<Map<String, String>>> loadInventoryItemsDB(String userID) {
    try {
      final userInventoryRef = db.collection('users').doc(userID).collection('inventory');

      // Using snapshots() for real-time updates
      return userInventoryRef.snapshots().map((querySnapshot) {
        // Transform each document into a map containing id and assetPath
        final inventoryItems = querySnapshot.docs.map((doc) {
          return {
            "id": doc.id, // Document ID
            "assetPath": doc.data()['path'] as String, // Asset path from document data
          };
        }).toList();

        return inventoryItems; // Return the list of maps
      });
    } catch (e) {
      // Handle errors (e.g., log them, display an error message)
      print('Error fetching inventory items: $e');
      return Stream.value([]); // Return an empty list as a stream in case of error
    }
  }

  Future<Map<String, dynamic>> getItemInfoDB(String userID, String itemID) async {
    try {
      final itemRef = db.collection('users').doc(userID).collection('inventory').doc(itemID);
      final itemSnapshot = await itemRef.get();

      if (itemSnapshot.exists) {
        final itemData = itemSnapshot.data();
        return {
          "quantity": itemData?['quantity'] as int,
          "replenish": itemData?['replenish'] as int,
        };
      } else {
        // If the document doesn't exist, return default or empty values
        print('Item not found: $itemID');
        return {
          "quantity": 0,
          "replenish": 0,
        };
      }
    } catch (e) {
      // Handle errors (e.g., log them, display an error message)
      print('Error fetching item info: $e');
      return {
        "quantity": 0, // Default value in case of error
        "replenish": 0, // Default value in case of error
      };
    }
  }

  Future<void> useItemDB(String userID, String itemID) async {
    final itemRef = db.collection('users').doc(userID).collection('inventory').doc(itemID);
    final itemSnapshot = await itemRef.get();

    // final Map<String, dynamic> itemData = storeSnapshot.data() as Map<String, dynamic>;
    // final int cost = itemData['cost'];

    final Map<String, dynamic> itemData = itemSnapshot.data() as Map<String, dynamic>;
    final int itemQuantity = (itemData['quantity']) ?? 0;

    if (itemQuantity <= 1) {
      await itemRef.delete();
    }
    else {
      await itemRef.update({'quantity': FieldValue.increment(-1)});
    }
  }

  Future<void> addCompletedFocusToDB(String userID, int duration) async {
    try {
      // Fetch the number of completed tasks
      var querySnapshot = await db.collection('users').doc(userID).collection('completedFocus').get();
      int focusNum = querySnapshot.docs.length; //get amount of tasks

      // Generate a new task number and name
      int newFocusNum = focusNum + 1;
      String newFocusName = newFocusNum.toString();

      final data = <String, dynamic>{
        "dateCompleted": DateTime.now(),
        "focusDuration": duration
      };

      await db.collection('users').doc(userID).collection('completedFocus').doc(newFocusName).set(data);

    } catch (e) {
      print("Error completing task '$duration': $e");
    }
  }

} // class
