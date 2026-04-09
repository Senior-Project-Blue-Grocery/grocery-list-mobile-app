import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/models/grocery_list.dart';
import 'package:grocery_app/screens/home_screen.dart';
import 'package:grocery_app/services/firestore_service.dart';

/*
TODO: CHANGE TO ITEMS LIST PAGE

remove the add button and textfield
just show the complete list of user's items in the specified grocery list

*/

class AddItemsScreen extends StatefulWidget {
  final GroceryList groceryList;

  const AddItemsScreen({
    super.key,
    required this.groceryList
  });

  @override
  State<AddItemsScreen> createState() => _AddItemsScreenState();
}

final FirestoreService firestoreDB = FirestoreService();

class _AddItemsScreenState extends State<AddItemsScreen> {
  final TextEditingController itemController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;
  int _navIndex = 1;

  FirestoreService firestoreService = FirestoreService();


  @override
  Widget build(BuildContext context) {
    final groceryList = widget.groceryList;

    return Scaffold(
      appBar: AppBar(
        title: Text(groceryList.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
                children: [
                  Expanded(
                    child:TextField(
                    controller: itemController,
                    decoration: const InputDecoration(
                      hintText: 'Enter grocery item',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    await firestoreService.addItem(
                      user!.uid, 
                      groceryList.id, 
                      GroceryItem(
                        id: '', 
                        name: itemController.text, 
                        quantity: 1, 
                        completed: false));
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<GroceryItem>>(
              stream: firestoreService.getItems(groceryList.id),

              builder: (context, snapshot) {

                // loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // no data
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('No grocery items yet')
                    );
                }

                // handle errors
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }  

                final items = snapshot.data!;

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    //final data = item.data() as Map<String, dynamic>;
                    
                    
                    return ListTile(
                      title: Text(item.name),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await firestoreService.deleteItem(
                            groceryList.id, 
                            item.id);
                        },
                      ),
                    );
                    
                    
                    /*
                    return CheckboxListTile(
                      title: Text(item.name),
                      value: item['completed'] ?? false,
                      onChanged: (bool? value) async {
                        await firestoreService.toggleItem(groceryList.id, item.id, value!);
                      },
                    );
                    */
                    
                  },
                );
              },
            ),
          ),
        ],
      ),

      /*
      // Bottom nav like the screenshot
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF2E7DFF),

        // THIS is the real fix
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
          // Home button → go to HomeScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        } else {
          // Any other icon → just change the selected highlight
          setState(() {
            _navIndex = i;
          });
        }
      },
        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
      ),
      */


    );
  }
}