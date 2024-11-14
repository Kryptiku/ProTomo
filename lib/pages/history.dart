// history_page.dart
import 'package:flutter/material.dart';
import 'home.dart'; // Ensure this imports where _historyTasks is defined.

class HistoryPage extends StatelessWidget {
  final List<Task> historyTasks;

  const HistoryPage({Key? key, required this.historyTasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task History"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: historyTasks.isNotEmpty
            ? ListView.builder(
          itemCount: historyTasks.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                historyTasks[index].title,
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'VT323',
                  color: Colors.white,
                ),
              ),
              trailing: Icon(
                Icons.check_circle,
                color: Colors.greenAccent,
              ),
            );
          },
        )
            : Center(
          child: Text(
            "No completed tasks yet.",
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'VT323',
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
