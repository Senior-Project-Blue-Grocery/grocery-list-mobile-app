import 'package:cloud_firestore/cloud_firestore.dart';

class CatalogItem {
  final String id;
  final String name;
  final String category;
  final List<String> keywords;
  final double price;
  final String imageUrl;

  CatalogItem({
    required this.id,
    required this.name,
    required this.category,
    required this.keywords,
    required this.price,
    required this.imageUrl,
  });

  // Convert firestore to dart catalog item
  factory CatalogItem.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CatalogItem.fromFirestore(doc.id, data);
  }

  factory CatalogItem.fromFirestore(String id, Map<String, dynamic> data) {
    return CatalogItem(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      keywords: List<String>.from(data['keywords'] ?? []),
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  // Convert catalog item to firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'keywords': keywords,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}