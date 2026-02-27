import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_app/screens/add_items_screen.dart';

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
    // TODO: implement build
    throw UnimplementedError();
  }

}
