import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:protomo/pages/audio_service.dart';
import 'package:protomo/dbtest.dart';
import 'package:protomo/pages/closet.dart';
import 'package:protomo/animations.dart';
import 'package:protomo/pages/settings.dart';
import 'package:protomo/pet_state.dart';
import 'package:protomo/dirtiness_overlay.dart';
import 'history.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlameAudio.audioCache
      .loadAll(['sample_bg_music.mp3', 'sample_sound_fx.mp3']);
  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late PetState pet;
  late Future<List<String>> _tasksNamesFuture;
  final db = FirestoreTest();

  // We now use a stream to get real-time updates from Firestore.
  Stream<List<String>> _taskStream = Stream.empty();

  @override
  void initState() {
    super.initState();
    pet = PetState();
    // Initialize the stream to get tasks from Firestore
    _taskStream = _getTasksFromFirestore();
  }

  @override
  void dispose() {
    pet.dispose();
    super.dispose();
  }
  List<String> tasks = [];

  // Fetch tasks from Firestore in real-time
  Stream<List<String>> _getTasksFromFirestore() {
    return db.getTasksDB('user1').asStream(); // Stream of tasks
  }

  void _addTask(String taskTitle) {
    setState(() {
      // Remove the task from the list
      tasks.add(taskTitle);
    });
    db.addTaskDb('user1', taskTitle); // Add task to Firestore
  }

  void _toggleTaskDone(int index, String taskTitle) {

    db.finishTaskDb('user1', taskTitle); // Mark task as completed in Firestore
    setState(() {
      // Remove the task from the list
      tasks.removeAt(index);
    });
  }

  void _feedPet() {
    setState(() {
      pet.feed(10);
    });
  }

  void _cleanTank() {
    setState(() {
      pet.cleanTank();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: _taskStream, // Stream to get real-time updates
      builder: (context, snapshot) {
         tasks = snapshot.data ?? [];

        return Scaffold(
          body: SafeArea(
            top: false,
            bottom: false,
            child: GestureDetector(
              onTap: () {
                AudioService.playSoundFx();
              },
              child: Container(
                child: Stack(
                  children: [
                    // Your existing UI components like background, buttons, etc.
                    // I won't repeat the whole UI structure here to keep it concise.
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
                        imagePath: "assets/axolotl/Baby-Pink-Axolotl-2.png",
                        bobbingDistance: 40.0,
                        bobbingDuration: 5,
                        rotationDuration: 50,
                        width: 200,
                        height: 200,
                      ),),
                    DirtinessOverlay(
                      dirtinessLevel: pet.tankLevel,
                      maxDirtinessLevel: PetState.MAX_TANK_LEVEL,
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 20,
                      left: 10,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Health: ${pet.health}',
                              style: TextStyle(color: Colors.white, fontFamily: 'VT323', fontSize: 20),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Tank Level: ${pet.tankLevel}',
                              style: TextStyle(color: Colors.white, fontFamily: 'VT323', fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                GestureDetector(
                                  onTap: () {
                                    print('clean');
                                    _cleanTank();
                                  },
                                  child: SizedBox(
                                    width: 60.0,
                                    height: 60.0,
                                    child: Image.asset(
                                      'assets/buttons/calendar.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    AudioService.playSoundFx();
                                    print('Start Timer');
                                    Navigator.pushNamed(context, '/focus');
                                  },
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Image.asset(
                                      'assets/buttons/start.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => HistoryPage(),
                                        )
                                    );
                                  },
                                  child: SizedBox(
                                    width: 70,
                                    height: 70,
                                    child: Image.asset(
                                      'assets/buttons/history.png',
                                    ),
                                  ),
                                )
                              ],
                            )
                          ]),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showSettings(context);

                                  },
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Image.asset(
                                      'assets/buttons/settings.png',
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                StreamBuilder<String>(
                                  stream: db.showCoins('user1'), // Listen to the stream for real-time updates
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return CircularProgressIndicator(); // Show loading indicator while waiting for the result
                                    }
                                    return Text('${snapshot.data}'); // Display the coins when data is available
                                  },
                                ),
                                Image.asset(
                                  'assets/buttons/coin.png',
                                  height: 45,
                                  fit: BoxFit.contain,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    AudioService.playBackgroundMusic();
                                  },
                                  child: SizedBox(
                                    width: 25,
                                    height: 25,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showClosetShop(context);
                                    AudioService.playSoundFx();
                                  },
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Image.asset(
                                      'assets/buttons/briefcase.png',
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
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
                        imagePath: "assets/axolotl/Baby-Pink-Axolotl-2.png",
                        bobbingDistance: 40.0,
                        bobbingDuration: 5,
                        rotationDuration: 50,
                        width: 200,
                        height: 200,
                      ),),
                    DirtinessOverlay(
                      dirtinessLevel: pet.tankLevel,
                      maxDirtinessLevel: PetState.MAX_TANK_LEVEL,
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 20,
                      left: 10,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Health: ${pet.health}',
                              style: TextStyle(color: Colors.white, fontFamily: 'VT323', fontSize: 20),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Tank Level: ${pet.tankLevel}',
                              style: TextStyle(color: Colors.white, fontFamily: 'VT323', fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                GestureDetector(
                                  onTap: () {
                                    print('clean');
                                    _cleanTank();
                                  },
                                  child: SizedBox(
                                    width: 60.0,
                                    height: 60.0,
                                    child: Image.asset(
                                      'assets/buttons/calendar.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    AudioService.playSoundFx();
                                    print('Start Timer');
                                    Navigator.pushNamed(context, '/focus');
                                  },
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Image.asset(
                                      'assets/buttons/start.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => HistoryPage(),
                                        )
                                    );
                                  },
                                  child: SizedBox(
                                    width: 70,
                                    height: 70,
                                    child: Image.asset(
                                      'assets/buttons/history.png',
                                    ),
                                  ),
                                )
                              ],
                            )
                          ]),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showSettings(context);

                                  },
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Image.asset(
                                      'assets/buttons/settings.png',
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                StreamBuilder<String>(
                                  stream: db.showCoins('user1'), // Listen to the stream for real-time updates
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return CircularProgressIndicator(); // Show loading indicator while waiting for the result
                                    }
                                    return Text('${snapshot.data}'); // Display the coins when data is available
                                  },
                                ),
                                Image.asset(
                                  'assets/buttons/coin.png',
                                  height: 45,
                                  fit: BoxFit.contain,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    AudioService.playBackgroundMusic();
                                  },
                                  child: SizedBox(
                                    width: 25,
                                    height: 25,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showClosetShop(context);
                                    AudioService.playSoundFx();
                                  },
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Image.asset(
                                      'assets/buttons/briefcase.png',
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),

                    // Tasks list widget
                    Positioned(
                      bottom: 100, // Adjust based on UI requirements
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 250, // Adjust height as needed
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Tasks",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
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
                                itemCount: tasks.length,
                                itemBuilder: (context, index) {
                                  String taskTitle = tasks[index];
                                  return CustomTaskTile(
                                    task: Task(title: taskTitle),
                                    onToggle: () => _toggleTaskDone(index, taskTitle),
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
            ),
          ),
        );
      },
    );
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
}

class CustomTaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;

  const CustomTaskTile({Key? key, required this.task, required this.onToggle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(
      fontFamily: 'VT323',
      fontSize: 30,
      color: Colors.white,
    );

    return ListTile(
      title: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Text(
            task.title,
            style: textStyle,
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
