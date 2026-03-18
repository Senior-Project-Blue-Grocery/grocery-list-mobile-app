
import 'package:cloud_firestore/cloud_firestore.dart';

class GroceryList {
  final String id;
  final String name;
  final String ownerId;
  final List<String> sharedWith;
  final int itemCount;

  GroceryList({
    required this.id,
    required this.name, required this.ownerId,
    required this.sharedWith,
    required this.itemCount
  });

  // converts firestore list data to dart object
  factory GroceryList.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return GroceryList(
      id: doc.id, 
      name: data['name'] ?? '',
      ownerId: data['ownerId'] ?? '',
      sharedWith: List<String>.from(data['sharedWith'] ?? []),
      itemCount: data['itemCount'] ?? 0
      );
  }

  // converts dart object to firestore list
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ownerId': ownerId,
      'sharedWith': sharedWith,
      'itemCount': itemCount
    };
  }
}