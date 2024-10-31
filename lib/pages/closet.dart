import 'package:flutter/material.dart';
import 'package:protomo/pages/home.dart';

void main() => runApp(const Home());

class ClosetShop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
            decoration: const BoxDecoration(
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
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              children: [
                                Image.asset(
                                  'assets/buttons/chicken.png',
                                  width: 40,
                                  height: 40,
                                ),
                                Image.asset(
                                  'assets/buttons/hanger.png',
                                  width: 40,
                                  height: 40,
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const Text('Closet'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Shop'),
                            const SizedBox(
                              width: 8,
                            ),
                            Image.asset(
                              'assets/buttons/shop.png',
                              width: 40,
                              height: 40,
                            )
                          ],
                        ),
                      ),
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Closet',
                                style: TextStyle(fontSize: 18),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    'assets/buttons/medicine.png',
                                    height: 50,
                                    width: 50,
                                  ),
                                  Image.asset(
                                    'assets/buttons/chicken.png',
                                    height: 50,
                                    width: 50,
                                  ),
                                  Image.asset(
                                    'assets/buttons/medicine.png',
                                    height: 50,
                                    width: 50,
                                  ),
                                  Image.asset(
                                    'assets/buttons/chicken.png',
                                    height: 50,
                                    width: 50,
                                  ),
                                  Image.asset(
                                    'assets/buttons/medicine.png',
                                    height: 50,
                                    width: 50,
                                  ),
                                  Image.asset(
                                    'assets/buttons/chicken.png',
                                    height: 50,
                                    width: 50,
                                  ),
                                  Image.asset(
                                    'assets/buttons/medicine.png',
                                    height: 50,
                                    width: 50,
                                  ),
                                  Image.asset(
                                    'assets/buttons/chicken.png',
                                    height: 50,
                                    width: 50,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        // Shop Tab
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Shop Items',
                                style: TextStyle(fontSize: 18),
                              ),
                              Row(
                                children: [
                                  Stack(
                                    children: [
                                      Image.asset(
                                        'assets/buttons/chicken.png',
                                        height: 70,
                                        width: 70,
                                      ),
                                      Positioned(
                                          top: 40,
                                          child: Container(
                                            margin: const EdgeInsets.all(10),
                                            child: Image.asset(
                                              'assets/buttons/coin.png',
                                              height: 20,
                                              width: 20,
                                            ),
                                          )),
                                      Positioned(
                                        top: 40,
                                        left: 20,
                                        child: Container(
                                          margin: const EdgeInsets.all(10),
                                          child: const Text('40'),
                                        ),
                                      )
                                    ],
                                  ),
                                  Stack(
                                    children: [
                                      Image.asset(
                                        'assets/buttons/chicken.png',
                                        height: 70,
                                        width: 70,
                                      ),
                                      Positioned(
                                          top: 40,
                                          child: Container(
                                            margin: const EdgeInsets.all(10),
                                            child: Image.asset(
                                              'assets/buttons/coin.png',
                                              height: 20,
                                              width: 20,
                                            ),
                                          )),
                                      Positioned(
                                        top: 40,
                                        left: 20,
                                        child: Container(
                                          margin: const EdgeInsets.all(10),
                                          child: const Text('10'),
                                        ),
                                      )
                                    ],
                                  ),
                                  Stack(
                                    children: [
                                      Image.asset(
                                        'assets/buttons/chicken.png',
                                        height: 70,
                                        width: 70,
                                      ),
                                      Positioned(
                                          top: 40,
                                          child: Container(
                                            margin: const EdgeInsets.all(10),
                                            child: Image.asset(
                                              'assets/buttons/coin.png',
                                              height: 20,
                                              width: 20,
                                            ),
                                          )),
                                      Positioned(
                                        top: 40,
                                        left: 20,
                                        child: Container(
                                          margin: const EdgeInsets.all(10),
                                          child: const Text('50'),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // close button for now
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          ));
    },
  );
}
