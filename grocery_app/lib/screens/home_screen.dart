import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_app/models/grocery_list.dart';
import 'package:grocery_app/screens/CatalogScreen.dart';
import 'package:grocery_app/screens/add_items_screen.dart';
import 'package:grocery_app/services/firestore_service.dart';
import 'package:grocery_app/services/populate_catalog.dart';

// this screen adds grocery lists to
// users/{uid}/grocery_lists/{listId} then navigates to
// users/{uid}/grocery_lists/{listId}/items to add items
// real-time updates with StreamBuilder

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController listController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;


  

  FirestoreService firestoreService = FirestoreService();


// used once to initially populate the global catalog in the database 

@override
void initState() {
  super.initState();
  PopulateCatalog().seedCatalog();
}




 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Grocery Lists'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            }, 
            icon: Icon(Icons.logout)
            )
        ],
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
                    await firestoreService.createList(GroceryList(
                      id: '',
                      name: listController.text, 
                      ownerId: user!.uid, 
                      sharedWith: [], 
                      itemCount: 0,
                      createdAt: Timestamp.now())
                      );
                  },
                  child: const Text('Add')
                ),
              ],
            ),
          ),
          Expanded( 
            child: StreamBuilder<List<GroceryList>>(
              stream: firestoreService.getUserLists(user!.uid),
           
              builder: (context, snapshot) {

                // loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                // empty data
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No grocery lists yet'),
                  );
                }
                // handle errors
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
                    
                    final count = list.itemCount;

                    return ListTile(
                      title: Text(list.name),
                      subtitle: Text('$count items'),

                      // Move to AddItems Screen
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (_) => AddItemsScreen(
                              groceryList: list
                            ),
                          ),
                        );
                      },
                      trailing: IconButton(
                        // delete selected list
                        onPressed: () async {
                          await firestoreService.deleteList(list.id);
                        }, 
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}

