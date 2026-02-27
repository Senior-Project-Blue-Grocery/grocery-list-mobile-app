import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddItemsScreen extends StatefulWidget {
  final String groceryListId;

  const AddItemsScreen({
    super.key,
    required this.groceryListId
  });

  @override
  State<AddItemsScreen> createState() => _AddItemsScreenState();
}



class _AddItemsScreenState extends State<AddItemsScreen> {
  final TextEditingController itemController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;
  

  CollectionReference<Map<String, dynamic>> get itemsRef => FirebaseFirestore
      .instance
      .collection('users')
      .doc(user!.uid)
      .collection('grocery_lists')
      .doc(widget.groceryListId)
      .collection('items');


  // Add item to user list and database
  Future<void> addItem() async {
    if (user == null) return;

    final item_name = itemController.text.trim();
    if (item_name.isEmpty) return;

    // adds items to list using item reference
    await itemsRef.add({
        'name': item_name,
        'createdAt': Timestamp.now(),
      });

    itemController.clear();
  }

  // Deletes item from user list
  Future<void> deleteItem(String id) async {
    await itemsRef.doc(id).delete();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groceryListId),
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
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
            children: [ TextField(
            //Expanded(
                  //child: TextField(

                    controller: itemController,
                    decoration: const InputDecoration(
                      hintText: 'Enter grocery item',
                      border: OutlineInputBorder(),
                    ),
                  ),
                
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: addItem,
                  child: const Text('Add'),
                ),
              
            ],
      ),
      ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: itemsRef
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No grocery items yet'));
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final name = doc.data()['name'] ?? '';

                    return ListTile(
                      title: Text(name),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteItem(doc.id),
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