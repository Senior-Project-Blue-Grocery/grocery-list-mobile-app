import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Grocery List"),
        actions: [
          IconButton(
            onPressed: () async {
              // Firebase logout goes here
              await FirebaseAuth.instance.signOut();

              Navigator.pop(context);
            }, 
            icon: const Icon(Icons.logout)),
        ],
      ),
      body: const Center(
        child: Text(
          "No items yet",
          style: TextStyle(fontSize: 18),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add items dialog goes here
        },
        child: const Icon(Icons.add),
        
      ),

    );
  }
}