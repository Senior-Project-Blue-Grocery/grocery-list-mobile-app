import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_app/screens/add_items_screen.dart';

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

  // get a reference if the user's grocery lists
  CollectionReference<Map<String, dynamic>> get listsRef =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('grocery_lists');

  // create new grocery list
  Future<void> addList() async {
    final listName = listController.text.trim();

    if (listName.isEmpty) return;

    await listsRef.add({
      'name': listName,
      'createdAt': Timestamp.now()
    });

    listController.clear();
  }       


  // deletes grocery list
  Future<void> deleteList(String id) async {
    await listsRef.doc(id).delete();
  }



 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery Lists'),
      ),
      body: Column(
        children: [
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
                  onPressed: addList, 
                  child: const Text('Add')
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: listsRef
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
           
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No grocery lists yet'),
                  );
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final name = doc.data()['name'] ?? '';

                    return ListTile(
                      title: Text(name),
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (_) => AddItemsScreen(
                              groceryListId: doc.id
                            ),
                          ),
                        );
                      },
                      trailing: IconButton(
                        onPressed: () => deleteList(doc.id), 
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
