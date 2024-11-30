import 'package:flutter/material.dart';
import 'package:protomo/dbtest.dart';
import 'package:protomo/pages/home.dart';
import 'package:provider/provider.dart';
import '../pet_state.dart';


final db = FirestoreTest();
final pet = PetState();
final home = HomeState();
String loggedUserID = 'user1';

Widget buyButton(String foodId, String assetPath) {
  return FutureBuilder<String>(
    future: db.getItemCost(foodId), // Fetch the cost dynamically
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return SizedBox(
          height: 70,
          width: 70,
          // child: CircularProgressIndicator(), // Loading indicator while fetching
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
                        db.buyItem(loggedUserID, foodId); // Purchase the item\
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

class ClosetShopDialog extends StatefulWidget {
  final String userID;
  late PetState pet;

  ClosetShopDialog({required this.userID});

  void initState() {
    // super.initState();
    pet = PetState();
  }

  @override
  State<ClosetShopDialog> createState() => _ClosetShopDialogState();
}

class _ClosetShopDialogState extends State<ClosetShopDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/buttons/asset.png'),
            fit: BoxFit.cover,
          ),
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
                        Image.asset(
                          'assets/buttons/hanger.png',
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Closet',
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Shop',
                          style: TextStyle(fontSize: 22),
                        ),
                        const SizedBox(width: 8),
                        Image.asset(
                          'assets/buttons/shop.png',
                          width: 40,
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              // Tab bar view for Closet and Shop
              Expanded(
                child: TabBarView(
                  children: [
                    // Closet Tab
                    _buildClosetTab(widget.userID),
                    // Shop Tab
                    _buildShopTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClosetTab(String userID) {
    return StreamBuilder<List<Map<String, String>>>(
      stream: db.loadInventoryItemsDB(userID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'Your closet is empty.',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          );
        }

        final items = snapshot.data!;
        return SingleChildScrollView(
          child: Wrap(
            spacing: 10.0,
            runSpacing: 20.0,
            children: items.map((item) {
              final itemID = item['id']!;
              final assetPath = item['assetPath']!;

              return _useButton(userID, itemID, assetPath);
            }).toList(),
          ),
        );
      },
    );
  }


  Widget _buildShopTab() {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 10.0,
        runSpacing: 20.0,
        children: [
          buyButton('food1', 'assets/buttons/chicken.png'),
          buyButton('meds1', 'assets/buttons/medicine.png'),
        ],
      ),
    );
  }

  Widget _useButton(String userID, String itemID, String assetPath) {
    final pet = context.watch<PetState>();

    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            // Fetch item details outside the builder
            final itemInfo = await db.getItemInfoDB(userID, itemID);
            final quantity = itemInfo?['quantity'] ?? 0;
            final replenish = itemInfo?['replenish'] ?? 0;

            if (quantity > 0) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Use Item'),
                    content: Text(
                      'Do you want to use this item? This will add $replenish health for your Tomo. Current Health: ${pet
                          .health}',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context), // Cancel
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                          db.useItemDB(userID,
                              itemID); // Use the item (decrease quantity)
                          pet.feed(replenish);
                        },
                        child: Text('Confirm'),
                      ),
                    ],
                  );
                },
              );
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Out of Stock'),
                    content: Text('This item is out of stock.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context), // OK
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: Image.asset(
            assetPath,
            height: 70,
            width: 70,
          ),
        ),
        FutureBuilder<Map<String, dynamic>>(
          future: db.getItemInfoDB(userID, itemID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...',
                  style: TextStyle(fontSize: 16, color: Colors.white));
            }
            if (snapshot.hasError) {
              return Text(
                  'Error', style: TextStyle(fontSize: 16, color: Colors.red));
            }

            final quantity = snapshot.data?['quantity'] ?? 0;

            return Text(
              'Quantity: $quantity',
              style: TextStyle(fontSize: 16, color: Colors.white),
            );
          },
        ),
      ],
    );
  }
}
