import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController itemController = TextEditingController();

  String? get userId => FirebaseAuth.instance.currentUser?.uid;

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

  final uid = userId;

  return Scaffold(
    appBar: AppBar(
      title: const Text('My Grocery List'),
    ),
    body: Column(
      children: [

        // Add item input field
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: itemController,
                  decoration: const InputDecoration(
                    hintText: "Enter grocery item",
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: addItem,
              )
            ],
          ),
        ),

        // Grocery List
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: itemsRef.orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snapshot) {

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No items yet"));
              }

              final docs = snapshot.data!.docs;

              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  final data = doc.data();

                  return Card(
                    elevation: 3,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),

                      // Checkbox
                      leading: Checkbox(
                        value: data["completed"] ?? false,
                        onChanged: (value) {
                          doc.reference.update({"completed": value});
                        },
                      ),

                      // Item name
                      title: Text(
                        data["name"] ?? "",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          decoration: (data["completed"] ?? false)
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: (data["completed"] ?? false)
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),

                      // Delete button
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteItem(doc.id),
                      ),
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
