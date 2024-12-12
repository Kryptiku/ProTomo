import 'package:flutter/material.dart';
import 'package:protomo/database_functions.dart';
import 'package:provider/provider.dart';
import '../pet_state.dart';
import '../skin_state.dart';


final db = FirestoreService();
final pet = PetState();
String defaultSkin = 'assets/axolotl/pinkfloating.png';
String loggedUserID = db.getCurrentUserId().toString();

Widget buyButton(String itemID, String assetPath) {


  return FutureBuilder<String>(
    future: db.getItemCost(itemID), // Fetch the cost dynamically
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
          String itemType = await db.getItemType(itemID);
          bool skinExistsInventory = await db.skinExistsInventory(loggedUserID, itemID);
          print(itemType);
          print(itemID);
          print(skinExistsInventory);

          if (userCoins >= itemCost) {
            if (itemType == 'skin') {
              if (skinExistsInventory){
                // You already have this dialogbox
                print('pumasok na sa skinExistsInventory');
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      backgroundColor: Colors.transparent,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Item Owned',
                              style: TextStyle(
                                fontFamily: 'VT323',
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'This item is already owned',
                              style: TextStyle(
                                fontFamily: 'VT323',
                                fontSize: 26,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'OK',
                                  style: TextStyle(
                                    fontFamily: 'VT323',
                                    color: Colors.white,
                                    fontSize: 26,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },);
              } else {
                purchaseConfirmation(itemCost, itemID, context);
              }
            } else {
              // Show confirmation dialog before purchasing
              purchaseConfirmation(itemCost, itemID, context);
            }
          } else {
            // Show insufficient coins dialog
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  backgroundColor: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Insufficient Coins',
                          style: const TextStyle(
                            fontFamily: 'VT323',
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'You need $itemCost coins to purchase this item, but you only have $userCoins coins.',
                          style: const TextStyle(
                            fontFamily: 'VT323',
                            fontSize: 26,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'OK',
                            style: TextStyle(
                              fontFamily: 'VT323',
                              color: Colors.white,
                              fontSize: 26,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
              top: 30,
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
              top: 20,
              left: 20,
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Text(snapshot.data ?? '',
                  style: TextStyle(
                      fontFamily: 'VT323',
                      fontSize: 28,
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

purchaseConfirmation(int itemCost, String itemID, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Confirm Purchase',
                style: const TextStyle(
                  fontFamily: 'VT323',
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Do you want to purchase this item for $itemCost coins?',
                style: const TextStyle(
                  fontFamily: 'VT323',
                  fontSize: 26,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context), // Cancel
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'VT323',
                        color: Colors.white,
                        fontSize: 26,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                      db.buyItem(loggedUserID, itemID); // Purchase the item
                    },
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontFamily: 'VT323',
                        color: Colors.white,
                        fontSize: 26,
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
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        height: 600,
        width: 500,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/buttons/asset.png'),
            fit: BoxFit.fitHeight,
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
                          style: TextStyle(
                            fontFamily: 'VT323',  // Apply the VT323 font
                            fontSize: 32,
                          ),
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
                          style: TextStyle(
                            fontFamily: 'VT323',  // Apply the VT323 font
                            fontSize: 32,
                          ),
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
              const SizedBox(height: 140.0),
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
          // Loading state positioned near the top-left
          return Padding(
            padding: const EdgeInsets.only(top: 20, left: 20),
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // Error state aligned to the top-left
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Empty state aligned to the top-left
          return Padding(
            padding: const EdgeInsets.all(120.0),
            child: Text(
              'Your closet is empty.',
              style: const TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontFamily: 'VT323',
              ),
            ),
          );
        }

        // Main content when data is available
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
          buyButton('skin1', 'assets/axolotl/Blue-Axolotl.png'),
          buyButton('skin2', 'assets/axolotl/Yellow-Axolotl.png'),
        ],
      ),
    );
  }

  Widget _useButton(String userID, String itemID, String assetPath) {
    final pet = context.watch<PetState>();
    final skinState = context.watch<SkinState>();

    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            final itemInfo = await db.getItemInfoDB(userID, itemID);
            final quantity = itemInfo?['quantity'] ?? 0;
            final replenish = itemInfo?['replenish'] ?? 0;
            final itemtype = itemInfo?['type'] ?? 'consumable';
            final assetPath = itemInfo?['path'];

            if (itemtype == 'skin') {
              if (quantity > 0) {
                if (skinState.defaultSkin == assetPath) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        backgroundColor: Colors.transparent,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Skin Already Equipped',
                                style: TextStyle(
                                  fontFamily: 'VT323',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'This skin is already in use.',
                                style: TextStyle(
                                  fontFamily: 'VT323',
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'OK',
                                  style: TextStyle(
                                    fontFamily: 'VT323',
                                    color: Colors.white,
                                    fontSize: 26,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        backgroundColor: Colors.transparent,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Use Item',
                                style: TextStyle(
                                  fontFamily: 'VT323',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Do you want to equip this skin?',
                                style: const TextStyle(
                                  fontFamily: 'VT323',
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      'No',
                                      style: TextStyle(
                                        fontFamily: 'VT323',
                                        color: Colors.white,
                                        fontSize: 26,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      skinState.changeSkin(assetPath);
                                      print('skin changed to $assetPath');
                                    },
                                    child: const Text(
                                      'Confirm',
                                      style: TextStyle(
                                        fontFamily: 'VT323',
                                        color: Colors.white,
                                        fontSize: 26,
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
              }
            } else {
              if (quantity > 0) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      backgroundColor: Colors.transparent,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Use Item',
                              style: TextStyle(
                                fontFamily: 'VT323',
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Do you want to use this item? This will add $replenish health for your Tomo. Current Health: ${pet
                                  .health}',
                              style: const TextStyle(
                                fontFamily: 'VT323',
                                fontSize: 24,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontFamily: 'VT323',
                                      color: Colors.white,
                                      fontSize: 26,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    db.useItemDB(userID, itemID);
                                    pet.feed(replenish);
                                  },
                                  child: const Text(
                                    'Confirm',
                                    style: TextStyle(
                                      fontFamily: 'VT323',
                                      color: Colors.white,
                                      fontSize: 26,
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
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      backgroundColor: Colors.transparent,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Out of Stock',
                              style: TextStyle(
                                fontFamily: 'VT323',
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'This item is out of stock.',
                              style: TextStyle(
                                fontFamily: 'VT323',
                                fontSize: 26,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'OK',
                                  style: TextStyle(
                                    fontFamily: 'VT323',
                                    color: Colors.white,
                                    fontSize: 26,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                assetPath,
                height: 70,
                width: 70,
              ),
              FutureBuilder<Map<String, dynamic>>(
                future: db.getItemInfoDB(userID, itemID),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  }
                  if (snapshot.hasError) {
                    return const SizedBox.shrink();
                  }

                  final quantity = snapshot.data?['quantity'] ?? 0;
                  return Positioned(
                    bottom: 1,
                    right: 15,
                    child: Text(
                      '$quantity' "x",
                      style: const TextStyle(
                        fontFamily: 'VT323',
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}