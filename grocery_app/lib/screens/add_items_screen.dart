import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddItemsScreen extends StatefulWidget {
  const AddItemsScreen({super.key});

  @override
  State<AddItemsScreen> createState() => _AddItemsScreenState();
}



class _AddItemsScreenState extends State<AddItemsScreen> {
  final TextEditingController itemController = TextEditingController();

  String get userId => FirebaseAuth.instance.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get itemsRef => FirebaseFirestore
      .instance
      .collection('users')
      .doc(userId)
      .collection('items');

  Future<void> addItem() async {
    final text = itemController.text.trim();
    if (text.isEmpty) return;


    // grocery item fields
    await itemsRef.add({
      'name': text,
      'createdAt': Timestamp.now(),
      'completed': false,
    });

    itemController.clear();
  }

  Future<void> deleteItem(String id) async {
    await itemsRef.doc(id).delete();
  }


  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Grocery List'),
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