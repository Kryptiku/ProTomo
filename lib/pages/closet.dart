import 'package:flutter/material.dart';
import 'package:protomo/pages/home.dart';

void main() => runApp(Home());

class ClosetShop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

void showClosetShop(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true, // Allows closing the dialog by tapping outside
    builder: (BuildContext context) {
      return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/buttons/closet.png'),
                  fit: BoxFit.fitWidth),
            ),
            child: DefaultTabController(
              length: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tab bar for Closet and Shop
                  TabBar(
                    labelColor: Colors.black,
                    indicatorColor: Colors.blue,
                    tabs: [
                      //i cant do shit, nagkakaerror pag ini stack ko yung images might be too big? i dont know
                      // Tab(
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       Image.asset(
                      //         '/assets/buttons/chicken.png',
                      //         width: 20,
                      //         height: 20,
                      //       ),
                      //       SizedBox(
                      //         width: 8,
                      //       ),
                      //       Text('Closet'),
                      //     ],
                      //   ),
                      // ),
                      Tab(text: 'Closet'),
                      Tab(text: 'Shop'),
                    ],
                  ),
                  // Tab bar view for each tab content
                  SizedBox(
                    height: 500, //height of the shop/closet
                    child: TabBarView(
                      children: [
                        // Closet Tab
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                //just placeholders for now
                                'Your Closet Items',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text('Closet Item 1'),
                              Text('Closet Item 2'),
                              Text('Closet Item 3'),
                            ],
                          ),
                        ),
                        // Shop Tab
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Shop Items',
                                style: TextStyle(fontSize: 18),
                              ),
                              // placeholders for now
                              Text('Shop Item 1'),
                              Text('Shop Item 2'),
                              Text('Shop Item 3'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // close button for now
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          ));
    },
  );
}
