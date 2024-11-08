import 'package:flutter/material.dart';
import 'package:protomo/pages/closet.dart';
import 'package:protomo/animations.dart';

void main() => runApp(const Home());

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Task> _tasks = [];

  void _addTask(String taskTitle) {
    setState(() {
      _tasks.add(Task(title: taskTitle, isDone: false));
    });
  }

  void _showAddTaskPopup() {
    final TextEditingController taskController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("New Task"),
          content: TextField(
            controller: taskController,
            decoration: InputDecoration(hintText: "Enter task title"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  _addTask(taskController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _toggleTaskDone(int index) {
    setState(() {
      _tasks[index].isDone = !_tasks[index].isDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/main_bg.png"),
                  fit: BoxFit.cover,
                  alignment: Alignment(-0.4, 0),
                ),
              ),
            ),
            Center(
              child: BobbingRotatingImage(
                imagePath: "assets/axolotl/Pink.png",
                bobbingDistance: 40.0,
                bobbingDuration: 5,
                rotationDuration: 50,
                width: 200,
                height: 200,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
                    child: Container(
                      height: 200,
                      width: 350,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tasks",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50,
                                  fontFamily: 'VT323',
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add, color: Colors.white),
                                onPressed: _showAddTaskPopup,
                              ),
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _tasks.length,
                              itemBuilder: (context, index) {
                                return CustomTaskTile(
                                  task: _tasks[index],
                                  onToggle: () => _toggleTaskDone(index),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildBottomNavBar(),
            _buildSettingsAndShopIcons(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _navIcon('assets/buttons/calendar.png', onTap: () {
              // Calendar navigation logic here
            }),
            _navIcon('assets/buttons/start.png', onTap: () {
              print('Start Timer');
              Navigator.pushNamed(context, '/focus');
            }),
            _navIcon('assets/buttons/history.png'),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsAndShopIcons() {
    return Positioned(
      top: 60,
      left: 0,
      child: _navIcon('assets/buttons/settings.png'),
    );
  }

  Widget _navIcon(String assetPath, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 60,
        height: 60,
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class CustomTaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;

  const CustomTaskTile({Key? key, required this.task, required this.onToggle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a TextPainter to measure text width
    final TextStyle textStyle = TextStyle(
      fontFamily: 'VT323',
      fontSize: 30,
      color: Colors.white,
    );

    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: task.title, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    final double textWidth = textPainter.width;

    return ListTile(
      title: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Text(
            task.title,
            style: textStyle,
          ),
          if (task.isDone)
            Positioned(
              left: 0,
              top: 15, // Adjust to center the line over the text
              child: Container(
                width: textWidth, // Match line length to text width
                height: 3, // Thickness of the line
                color: Colors.redAccent, // Color of the line
              ),
            ),
        ],
      ),
      trailing: Checkbox(
        value: task.isDone,
        onChanged: (_) => onToggle(),
        activeColor: Colors.redAccent,
      ),
    );
  }
}

class Task {
  final String title;
  bool isDone;

  Task({required this.title, this.isDone = false});
}
