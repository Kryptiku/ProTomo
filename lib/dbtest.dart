import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreTest {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> buyItem(String foodId) async {
    try {
      // Get the item document from the store collection
      final storeItemDoc = db.collection('store').doc(foodId);
      final DocumentSnapshot storeSnapshot = await storeItemDoc.get();

      if (storeSnapshot.exists) {
        // Retrieve the item's cost
        final Map<String, dynamic> itemData = storeSnapshot.data() as Map<String, dynamic>;
        final int cost = itemData['cost'];

        // Reference the user's coins
        final userDoc = db.collection('users').doc('user1');
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
              await userInventoryDoc.set({'quantity': 1, 'cost': cost});
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
      int taskNum = querySnapshot.docs.length;

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
      // Fetch the tasks from F irestore
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



} // class
