import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:protomo/pages/audio_service.dart';
import 'package:protomo/database_functions.dart';
import 'package:protomo/pages/closet.dart';
import 'package:protomo/animations.dart';
import 'package:protomo/pages/settings.dart';
import 'package:protomo/pet_state.dart';
import 'package:protomo/dirtiness_overlay.dart';
import 'package:provider/provider.dart';
import 'history.dart';
import 'dart:math' as math;

final db = FirestoreService();

String loggedUserID = db.getCurrentUserId().toString();
int taskReward = 5;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlameAudio.audioCache.loadAll([
    'sample_bg_music.mp3',
    'button_press.wav',
    'coin.wav',
    'popup_no.wav',
    'popup_yes.wav',
    'start_focus.wav',
    'stop_time.wav'
  ]);
  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final pet = PetState();
  late Future<List<String>> _tasksNamesFuture;

  //Coins Animation Params
  final int _coinValue = 5; //placeholder value
  final List<CoinAnimation> _animations = [];

  void _showCoinAnimation() {
    AudioService.coinFx();
    final random = math.Random();
    final startX =
        MediaQuery.of(context).size.width / 2 + random.nextDouble() * 40 - 20;
    final endX = startX + random.nextDouble() * 80 - 40;

    final controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    final animation = CoinAnimation(
      controller: controller,
      startX: startX,
      endX: endX,
    );

    setState(() {
      _animations.add(animation);
    });

    controller.forward().then((_) {
      setState(() {
        _animations.remove(animation);
      });
      controller.dispose();
    });
  }

  // We now use a stream to get real-time updates from Firestore.
  Stream<List<String>> _taskStream = Stream.empty();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Add observer for app lifecycle
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('sample_bg_music.mp3', volume: AudioService.bgmVolume);
    // Initialize the stream to get tasks from Firestore
    _taskStream = _getTasksFromFirestore();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer on dispose
    FlameAudio.bgm.stop(); // Stop BGM when the widget is disposed
    pet.dispose();
    super.dispose();

    for (var animation in _animations) {
      animation.controller.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      // if the app is in the background
      FlameAudio.bgm.pause();
    } else if (state == AppLifecycleState.resumed) {
      // resume when its on the foreground
      FlameAudio.bgm.resume();
    }
  }

  List<String> tasks = [];

  // Fetch tasks from Firestore in real-time
  Stream<List<String>> _getTasksFromFirestore() {
    return db.getTasksDB(loggedUserID).asStream(); // Stream of tasks
  }

  void _addTask(String taskTitle) {
    setState(() {
      // Remove the task from the list
      tasks.add(taskTitle);
    });
    db.addTaskDb(loggedUserID, taskTitle); // Add task to Firestore
  }

  void _toggleTaskDone(int index, String taskTitle) async {
    db.finishTaskDb(
        loggedUserID, taskTitle); // Mark task as completed in Firestore
    setState(() {
      // Remove the task from the list
      tasks.removeAt(index);
    });

    final completedTasksToday = await db.getCompletedTasksTodayDB(loggedUserID);
    final activeTasksToday = await db.getActiveTasksTodayDB(loggedUserID);

    if (completedTasksToday < 5) {
      rewardTasks();
    } else if (completedTasksToday == 5) {
      _showLimitReachedDialog();
    } // else if
    else {
      _showSnackBar("No more rewards for today.");
    }
  } // void

  Stream<int> getTasksLimitStream() async* {
    while (true) {
      final completedToday = await db.getCompletedTasksTodayDB(loggedUserID);
      final activeToday = await db.getActiveTasksTodayDB(loggedUserID);
      yield completedToday;
      await Future.delayed(Duration(seconds: 0)); // Poll every second
    }
  }

  void rewardTasks() {
    db.rewardUserDB(loggedUserID, taskReward);
    _showCoinAnimation(); //Animation Trigger
  }

  @override
  Widget build(BuildContext context) {
    final pet = context.watch<PetState>();

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
                AudioService.buttonPressFx();
              },
              child: Container(
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
                        imagePath: "assets/axolotl/pinkfloating.png",
                        bobbingDistance: 40.0,
                        bobbingDuration: 5,
                        rotationDuration: 50,
                        width: 200,
                        height: 200,
                      ),
                    ),
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
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'VT323',
                                  fontSize: 22),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Tank Level: ${pet.tankLevel}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'VT323',
                                  fontSize: 22),
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
                                  onTap: () async {
                                    final userID =
                                        loggedUserID; // Replace with actual user ID or context value
                                    final userCoins =
                                        await db.getUserCoins(userID);

                                    // Check if user has enough coins
                                    if (userCoins >= 10 && pet.tankLevel > 0) {
                                      // Show confirmation dialog
                                      bool? shouldProceed = await showDialog<bool>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12.0),
                                            ),
                                            backgroundColor: Colors.transparent,
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 20),
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.black54,
                                                borderRadius: BorderRadius.circular(12.0),
                                                border: Border.all(color: Colors.white, width: 2),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // Title
                                                  Text(
                                                    "Confirm Tank Cleaning",
                                                    style: const TextStyle(
                                                      fontFamily: 'VT323',
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 28,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 16),

                                                  // Content
                                                  Text(
                                                    "Do you want to spend 10 coins to clean the tank?",
                                                    style: const TextStyle(
                                                      fontFamily: 'VT323',
                                                      fontSize: 24,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 20),

                                                  // Buttons
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      // Cancel Button
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop(false); // Don't proceed
                                                        },
                                                        style: TextButton.styleFrom(
                                                          padding: const EdgeInsets.symmetric(
                                                              horizontal: 24, vertical: 12),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(8.0),
                                                          ),
                                                        ),
                                                        child: const Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                            fontFamily: 'VT323',
                                                            fontSize: 22,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      // Confirm Button
                                                      TextButton(
                                                        onPressed: () async {
                                                          await db.useCleanerDB(userID); // Deduct coins
                                                          final pet = context.read<PetState>();
                                                          pet.cleanTank(); // Clean the tank
                                                          Navigator.of(context).pop(true); // Proceed
                                                        },
                                                        style: TextButton.styleFrom(
                                                          padding: const EdgeInsets.symmetric(
                                                              horizontal: 24, vertical: 12),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(8.0),
                                                          ),
                                                        ),
                                                        child: const Text(
                                                          "Yes",
                                                          style: TextStyle(
                                                            fontFamily: 'VT323',
                                                            fontSize: 22,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );


                                      // Proceed with cleaning if the user confirmed
                                      if (shouldProceed == true) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content:
                                                  Text("Tank is now cleaner!")),
                                        );
                                      }
                                    } else if (pet.tankLevel == 0) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("Tank is already clean!")),
                                      );
                                    } else {
                                      // Show a message if the user doesn't have enough coins
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "You don't have enough coins!")),
                                      );
                                    }
                                  },
                                  child: SizedBox(
                                    width: 60.0,
                                    height: 60.0,
                                    child: Image.asset(
                                      'assets/buttons/spray.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    AudioService.startFocusFx();
                                    print('Start Timer');
                                    Navigator.pushReplacementNamed(context, '/focus');
                                  },
                                  child: SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Image.asset(
                                      'assets/buttons/focusbtn.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    AudioService.buttonPressFx();
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => HistoryPage(),
                                    ));
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
                            ),
                            // SizedBox(height: 10,),
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
                                    AudioService.buttonPressFx();
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
                        padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize
                                  .min, // Ensure the Column only takes as much space as needed
                              children: [
                                Image.asset(
                                  'assets/buttons/coin.png',
                                  height: 40,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(
                                    height:
                                        2), // Adds space between the coin image and the number
                                StreamBuilder<String>(
                                  stream: db.showCoins(loggedUserID),
                                  builder: (context, snapshot) {
                                    // Handle connection state, and data availability
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator(); // Loading indicator
                                    }

                                    // Display the coins when data is available
                                    return Text(
                                      '${snapshot.data}', // Display the coin number
                                      style: TextStyle(
                                        fontFamily: 'VT323', // Apply the VT323 font
                                        fontSize: 30,        // Set font size
                                        fontWeight: FontWeight.bold, // Bold text
                                        color: Colors.white, // Text color
                                      ),
                                    );
                                  },
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
                                    AudioService.buttonPressFx();
                                    showDialog(
                                      context:
                                          context, // Ensure this is the correct context
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return ClosetShopDialog(
                                            userID: loggedUserID);
                                      },
                                    );
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
                            ),
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
                        height: 250,
                        // Adjust height as needed
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
                            StreamBuilder<int>(
                              stream: getTasksLimitStream(),
                              builder: (context, snapshot) {
                                // if (snapshot.connectionState == ConnectionState.waiting) {
                                //   return CircularProgressIndicator();
                                // }
                                if (snapshot.hasError) {
                                  return Text("Error: ${snapshot.error}");
                                } else if (snapshot.hasData) {
                                  int tasksLimit = snapshot.data ?? 0;
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Tasks $tasksLimit/5",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 32,
                                          fontFamily: 'VT323',
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add,
                                            color: Colors.white),
                                        onPressed: _showAddTaskPopup,
                                      ),
                                    ],
                                  );
                                } else {
                                  return Text("No data available");
                                }
                              },
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: tasks.length,
                                itemBuilder: (context, index) {
                                  String taskTitle = tasks[index];
                                  return CustomTaskTile(
                                    task: Task(title: taskTitle),
                                    onToggle: () =>
                                        _toggleTaskDone(index, taskTitle),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ..._animations
                        .map((animation) => AnimatedBuilder(
                              animation: animation.controller,
                              builder: (context, child) {
                                final value = animation.controller.value;
                                final yOffset = 100 * value;
                                final xOffset =
                                    (animation.endX - animation.startX) *
                                        math.sin(value * math.pi);
                                return Positioned(
                                  left: animation.startX + xOffset,
                                  bottom:
                                      MediaQuery.of(context).size.height / 2 +
                                          25 +
                                          yOffset,
                                  child: Opacity(
                                    opacity: 1 - value,
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/buttons/coin.png',
                                          width: 50,
                                          height: 50,
                                        ),
                                        Text(
                                          '+$_coinValue',
                                          style: const TextStyle(
                                              fontSize: 32,
                                              color: Colors.white,
                                              fontFamily: 'VT323',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ))
                        .toList(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddTaskPopup() async {
    final TextEditingController taskController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
          ),
          backgroundColor: Colors.transparent, // Transparent background
          child: Container(
            height: 350, // Height of the popup
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black54, // Dark background with transparency
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.white, width: 2), // White border
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "New Task",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    fontFamily: 'VT323',
                    color: Colors.white, // Text color for visibility
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Enter task title:",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'VT323',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: taskController,
                  decoration: InputDecoration(
                    hintText: "Enter task title",
                    hintStyle:
                        TextStyle(color: Colors.white60), // Light hint text
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'VT323',
                      fontSize: 18
                  ), // Text color inside the field
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        AudioService.popupNoFx();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'VT323',
                          fontSize: 28,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        AudioService.popupYesFx();
                        if (taskController.text.isNotEmpty) {
                          _addTask(
                              taskController.text); // Add task functionality
                          Navigator.of(context)
                              .pop(); // Close dialog after adding task
                        }
                      },
                      child: const Text(
                        "Add",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'VT323',
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating, // Optional: Makes the SnackBar float
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showLimitReachedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Limit Reached"),
          content: Text("You have reached the limit of 5 rewardable tasks."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
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

  const CustomTaskTile({Key? key, required this.task, required this.onToggle})
      : super(key: key);

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
        side: BorderSide(color: Colors.white70, width: 2),
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

class CoinAnimation {
  final AnimationController controller;
  final double startX;
  final double endX;

  CoinAnimation(
      {required this.controller, required this.startX, required this.endX});
}
