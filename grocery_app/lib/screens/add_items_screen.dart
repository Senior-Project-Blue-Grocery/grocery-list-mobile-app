import 'package:flutter/material.dart';

class AddItemsScreen extends StatelessWidget {
  const AddItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return AlertDialog(
      title: const Text("Add Grocery Items"),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: "Milk, Eggs, Bread..."),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), 
          child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // Firebase save goes here
              Navigator.pop(context);
            }, 
            child: const Text("Add"),
          ),
      ],
    );
  }
}