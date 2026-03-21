import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/models/grocery_list.dart';
import 'package:grocery_app/services/firestore_service.dart';

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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No grocery items yet')
                    );
                }

                final items = snapshot.data!;

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    

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