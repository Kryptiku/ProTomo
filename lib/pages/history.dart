import 'package:flutter/material.dart';
import '../database_functions.dart';

final db = FirestoreService();
String loggedUserID = db.getCurrentUserId().toString();

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
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
        title: const Text(
          "Task History",
          style: TextStyle(
            fontFamily: 'VT323',
            fontSize: 28,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black54,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<String>>(
          future: _completedTaskNamesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while data is being fetched.
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.yellowAccent,
                ),
              );
            } else if (snapshot.hasError) {
              // Handle errors gracefully.
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontFamily: 'VT323',
                    color: Colors.redAccent,
                  ),
                ),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              // Display the completed task names in a ListView.
              final completedTaskNames = snapshot.data!;
              return ListView.builder(
                itemCount: completedTaskNames.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            completedTaskNames[index],
                            style: const TextStyle(
                              fontSize: 24,
                              fontFamily: 'VT323',
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.check_circle,
                          color: Colors.greenAccent,
                          size: 30,
                        ),
                      ],
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
