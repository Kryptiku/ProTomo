import 'package:flutter/material.dart';
import 'package:protomo/dbtest.dart';

final db = FirestoreTest();
String loggedUserID = 'user1';

Widget buyButton(String foodId, String assetPath) {
  return FutureBuilder<String>(
    future: db.getItemCost(foodId), // Fetch the cost dynamically
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return SizedBox(
          height: 70,
          width: 70,
          child: CircularProgressIndicator(), // Loading indicator while fetching
        );
      }
      if (snapshot.hasError) {
        return SizedBox(
          height: 70,
          width: 70,
          child: Center(child: Text('Error')), // Error state
        );
      }

      return GestureDetector(
        onTap: () async {
          int itemCost = int.parse(snapshot.data ?? '0'); // Cost of the item
          int userCoins = await db.getUserCoins(loggedUserID); // Fetch user's coins

          if (userCoins >= itemCost) {
            // Show confirmation dialog before purchasing
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Confirm Purchase'),
                  content: Text(
                    'Do you want to purchase this item for $itemCost coins?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context), // Cancel
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                        db.buyItem(loggedUserID, foodId); // Purchase the item
                      },
                      child: Text('Confirm'),
                    ),
                  ],
                );
              },
            );
          } else {
            // Show insufficient coins dialog
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Insufficient Coins'),
                  content: Text(
                    'You need $itemCost coins to purchase this item, but you only have $userCoins coins.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: Stack(
          children: [
            Image.asset(
              assetPath,
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
              ),
            ),
            Positioned(
              top: 40,
              left: 20,
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Text(snapshot.data ?? '',
                  style: TextStyle(
                      fontSize: 16,
                      color:Colors.white
                  ),
                ), // Display fetched cost
              ),
            ),
          ],
        ),
      );
    },
  );
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
                  image: AssetImage('assets/buttons/asset.png'),
                  fit: BoxFit.cover),
            ),
            child: DefaultTabController(
              length: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tab bar for Closet and Shop
                  TabBar(
                    labelColor: Colors.white,
                    indicatorColor: Colors.white,
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
                            const Text('Closet',
                              style: TextStyle(
                                  fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Shop',
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
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
                  SizedBox(height: 40.0),
                  // Tab bar view for each tab content
                  SizedBox(
                    height: 500, //height of the shop/closet
                    child: TabBarView(
                      children: [
                        // Closet Tab
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Closet',
                                style: TextStyle(
                                  fontSize: 28,
                                  color:Colors.white
                                ),
                              ),
                              SizedBox(height: 50.0),
                              Wrap(
                                spacing: 10.0,
                                runSpacing: 40.0,
                                children: [
                                  Image.asset(
                                    'assets/buttons/medicine.png',
                                    height: 70,
                                    width: 70,
                                  ),
                                  Image.asset(
                                    'assets/buttons/chicken.png',
                                    height: 70,
                                    width: 70,
                                  ),
                                  Image.asset(
                                    'assets/buttons/medicine.png',
                                    height: 70,
                                    width: 70,
                                  ),
                                  Image.asset(
                                    'assets/buttons/chicken.png',
                                    height: 70,
                                    width: 70,
                                  ),
                                  Image.asset(
                                    'assets/buttons/medicine.png',
                                    height: 70,
                                    width: 70,
                                  ),
                                  Image.asset(
                                    'assets/buttons/chicken.png',
                                    height: 70,
                                    width: 70,
                                  ),
                                  Image.asset(
                                    'assets/buttons/medicine.png',
                                    height: 70,
                                    width: 70,
                                  ),
                                  Image.asset(
                                    'assets/buttons/chicken.png',
                                    height: 70,
                                    width: 70,
                                  ),
                                  Image.asset(
                                    'assets/buttons/medicine.png',
                                    height: 70,
                                    width: 70,
                                  ),
                                  Image.asset(
                                    'assets/buttons/chicken.png',
                                    height: 70,
                                    width: 70,
                                  ),
                                  Image.asset(
                                    'assets/buttons/medicine.png',
                                    height: 70,
                                    width: 70,
                                  ),
                                  Image.asset(
                                    'assets/buttons/chicken.png',
                                    height: 70,
                                    width: 70,
                                  ),
                                  Image.asset(
                                    'assets/buttons/medicine.png',
                                    height: 70,
                                    width: 70,
                                  ),
                                  Image.asset(
                                    'assets/buttons/chicken.png',
                                    height: 70,
                                    width: 70,
                                  ),
                                  Image.asset(
                                    'assets/buttons/medicine.png',
                                    height: 70,
                                    width: 70,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        // Shop Tab
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Shop Items',
                                style: TextStyle(
                                    fontSize: 28,
                                    color:Colors.white
                                ),
                              ),
                              SizedBox(height: 50.0),
                              Wrap(
                                spacing: 10.0,
                                runSpacing: 40.0, //this determines the spacing when it goes to the next line
                                children: [
                                  buyButton('food1', 'assets/buttons/chicken.png'),
                                  buyButton('meds1', 'assets/buttons/medicine.png'),
                                  buyButton('food1', 'assets/buttons/chicken.png'),
                                  buyButton('meds1', 'assets/buttons/medicine.png'),
                                  buyButton('food1', 'assets/buttons/chicken.png'),
                                  buyButton('meds1', 'assets/buttons/medicine.png'),
                                  buyButton('food1', 'assets/buttons/chicken.png'),
                                  buyButton('meds1', 'assets/buttons/medicine.png')
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
    },
  );
}
