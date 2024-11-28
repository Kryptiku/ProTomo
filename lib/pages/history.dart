// history_page.dart
import 'package:flutter/material.dart';
import '../dbtest.dart';

String loggedUserID = 'user1';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final db = FirestoreTest();
  late Future<List<String>> _completedTaskNamesFuture;

  @override
  void initState() {
    super.initState();
    // Fetch task history when the page loads.
    _completedTaskNamesFuture = db.getCompletedTasksDB(loggedUserID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task History"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<String>>(
          future: _completedTaskNamesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while data is being fetched.
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              // Handle errors gracefully.
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontFamily: 'VT323',
                    color: Colors.red,
                  ),
                ),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              // Display the completed task names in a ListView.
              final completedTaskNames = snapshot.data!;
              return ListView.builder(
                itemCount: completedTaskNames.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      completedTaskNames[index],
                      style: const TextStyle(
                        fontSize: 24,
                        fontFamily: 'VT323',
                        color: Colors.white,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.check_circle,
                      color: Colors.greenAccent,
                    ),
                  );
                },
              );
            } else {
              // Show a message if no tasks are completed.
              return const Center(
                child: Text(
                  "No completed tasks yet.",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'VT323',
                    color: Colors.white,
                  ),
                ),
              );
            }
          },
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}

