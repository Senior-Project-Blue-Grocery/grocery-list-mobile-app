import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String first_name;
  final String last_name;
  final String email;
  final Timestamp createdAt;



  UserModel({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.createdAt
  
  });

  // convert firestore item to dart object
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      id: doc.id, 
      first_name: data['first_name'] ?? '', 
      last_name: data['last_name'] ?? '',
      email: data['email'] ?? '', 
      createdAt: data['createdAt'] ?? ''
      //quantity: data['quantity'] ?? 1, 
      //completed: data['completed'] ?? false
      );
  }


  // convert dart object to firestore item
  Map<String, dynamic> toMap() {
    return {
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'createdAt': createdAt
      //'completed': completed
    };
  }

}