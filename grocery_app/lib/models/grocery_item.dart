import 'package:cloud_firestore/cloud_firestore.dart';


class GroceryItem {
  final String id;
  final String name;
  final int quantity;
  final bool completed;


  GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.completed
  });

  // convert firestore item to dart object
  factory GroceryItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return GroceryItem(
      id: doc.id, 
      name: data['name'] ?? '', 
      quantity: data['quantity'] ?? 1, 
      completed: data['completed'] ?? false
      );
  }


  // convert dart object to firestore item
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'completed': completed
    };
  }

}