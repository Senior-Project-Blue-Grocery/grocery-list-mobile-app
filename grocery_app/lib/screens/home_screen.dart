import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_app/models/grocery_list.dart';
import 'package:grocery_app/screens/account_linking_screen.dart';
import 'package:grocery_app/screens/CatalogScreen.dart';
import 'package:grocery_app/screens/show_items_screen.dart';
import 'package:grocery_app/screens/account_screen.dart';
import 'package:grocery_app/screens/cart_screen.dart';
import 'package:grocery_app/services/firestore_service.dart';
import 'package:grocery_app/services/populate_catalog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController listController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  

  final FirestoreService firestoreService = FirestoreService();


// used to populate the global catalog in the database; runs when app restarts
/*
@override
void initState() {
  super.initState();
  PopulateCatalog().seedCatalog();
}
*/


  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 🔥 removes back arrow
        title: const Text('My Grocery Lists'),
      ),
      body: Column(
        children: [
          // header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: listController,
                    decoration: const InputDecoration(
                      labelText: 'Enter new list name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  // create a grocery list obj with 0 items, owner is user id of person currently logged in
                  onPressed: () async {           
                    if (listController.text.trim().isEmpty) return;

                    await firestoreService.createList(
                      GroceryList(
                      id: '',
                      name: listController.text.trim(), 
                      ownerId: user!.uid, 
                      sharedWith: [], 
                      itemCount: 0,
                      createdAt: Timestamp.now())
                      );

                    listController.clear();
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),

          
          Expanded(
            child: StreamBuilder<List<GroceryList>>(
              // pulls lists from firestore database
              stream: firestoreService.getUserLists(user!.uid),
              builder: (context, snapshot) {
                // loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No grocery lists yet'),
                  );
                }
                // error
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                final lists = snapshot.data!;

                return ListView.builder(
                  itemCount: lists.length,
                  itemBuilder: (context, index) {
                    final list = lists[index];
                    final isShared = list.ownerId != user!.uid;

                    return ListTile(
                      leading: Icon(
                        isShared ? Icons.people_alt_outlined : Icons.list_alt,
                        color: isShared ? Colors.blue : null,
                      ),
                      title: Text(list.name),
                      subtitle: Text(
                        isShared
                            ? '${list.itemCount} items • Shared list'
                            : '${list.itemCount} items',
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddItemsScreen(
                              groceryList: list,
                            ),
                          ),
                        );
                      },
                      trailing: list.ownerId == user!.uid
                          ? IconButton(
                              onPressed: () async {
                                await firestoreService.deleteList(list.id);
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            )
                          : null,
                    );
                  },
                );
              },
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
          if (i == 1) {
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
            icon: Icon(Icons.people_alt_outlined),
            label: "",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
      ),
    );
  }
}