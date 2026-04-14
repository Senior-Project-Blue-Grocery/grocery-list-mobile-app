import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/models/grocery_list.dart';
import 'package:grocery_app/screens/account_linking_screen.dart';
import 'package:grocery_app/screens/account_screen.dart';
import 'package:grocery_app/screens/cart_screen.dart';
import 'package:grocery_app/screens/home_screen.dart';
import 'package:grocery_app/screens/catalogscreen.dart';
import 'package:grocery_app/services/firestore_service.dart';

class AddItemsScreen extends StatefulWidget {
  final GroceryList groceryList;

  const AddItemsScreen({
    super.key,
    required this.groceryList,
  });

  @override
  State<AddItemsScreen> createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final FirestoreService firestoreService = FirestoreService();
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final groceryList = widget.groceryList;

    return Scaffold(
      appBar: AppBar(
        title: Text(groceryList.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<GroceryItem>>(
              stream: firestoreService.getItems(groceryList.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No grocery items yet'),
                  );
                }

                final items = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text('Qty: ${item.quantity}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await firestoreService.deleteItem(
                            groceryList.id,
                            item.id,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CatalogScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Add Items',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF2E7DFF),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 28,
        ),
        unselectedIconTheme: const IconThemeData(
          color: Colors.white70,
        ),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _navIndex,
        onTap: (i) {
          if (i == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else if (i == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CatalogScreen()),
            );
          } else if (i == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CartScreen()),
            );
          } else if (i == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AccountLinkingScreen(),
              ),
            );
          } else if (i == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AccountScreen()),
            );
          } else {
            setState(() {
              _navIndex = i;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined), // 👥 updated
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "",
          ),
        ],
      ),
    );
  }
}