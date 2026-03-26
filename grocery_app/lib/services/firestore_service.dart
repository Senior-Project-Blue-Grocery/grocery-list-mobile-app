import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/models/catalog_item.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/models/grocery_list.dart';

class FirestoreService {
  final FirebaseFirestore databaseConnection = FirebaseFirestore.instance;

  //
  // GROCERY LISTS FUNCTIONS
  //

  // create new list
  Future<void> createList(GroceryList list) async {
    await databaseConnection.collection('groceryLists').doc(list.id).set(list.toMap());
  }

  Stream<List<GroceryList>> getUserLists(String userId) {
    return databaseConnection
      .collection('groceryLists')
      .where('sharedWith', arrayContains: userId)
      .snapshots()
      .map((snapshot) => snapshot.docs
        .map((doc) => GroceryList.fromFirestore(doc))
      .toList());
  }

  // delete list
  Future<void> deleteList(String listId) async {
    await databaseConnection.collection('groceryLists').doc(listId).delete();
  }


  /*
  //
  // SHARING FUNCTIONS
  //

  // Share list with another user by uid
  Future<void> shareList(String listId, String userId) async {
    await databaseConnection.collection('groceryLists').doc(listId).update({
      'sharedWith': FieldValue.arrayUnion([userId])
    });
  }

  // Remove user from shared list
  Future<void> unshareList(String listId, String userId) async {
    await databaseConnection.collection('groceryLists').doc(listId).update({
      'sharedWith': FieldValue.arrayRemove([userId])
    });
  }

  // Check if user has access to list
  Future<bool> userHasAccess(String listId, String userId) async {
    final doc = await databaseConnection.collection('groceryLists').doc(listId).get();

    if (!doc.exists) return false;

    final data = doc.data() as Map<String, dynamic>;
    final ownerId = data['ownerId'];
    final shared = List<String>.from(data['sharedWith'] ?? []);

    return ownerId == userId || shared.contains(userId);
  }

  */

  //
  // Items in a list FUNCTIONS
  //

  // add an item to a list
  Future<void> addItem(String userId, String listId, GroceryItem item) async {
    await databaseConnection
      .collection('groceryLists')
      .doc(listId)
      .collection('items')
      .add(item.toMap());


    // increase item count
    await incrementItemCount(listId, 1);
  }

  // listen to items in list, updates automatically
  Stream<List<GroceryItem>> getItems(String listId) {
    return databaseConnection
      .collection('groceryLists')
      .doc(listId)
      .collection('items')
      .snapshots()
      .map((snapshot) => snapshot.docs
        .map((doc) => GroceryItem.fromFirestore(doc))
        .toList());
  }

  // mark item completed or not
  Future<void> toggleItem(String listId, String itemId, bool value) async {
    await databaseConnection
      .collection('groceryLists')
      .doc(listId)
      .collection('items')
      .doc(itemId)
      .update({'completed': value});
  }

  // delete item from list
  Future<void> deleteItem(String listId, String itemId, bool value) async {
    await databaseConnection
      .collection('groceryLists')
      .doc(listId)
      .collection('items')
      .doc(itemId)
      .delete();

    // decrease item count
    await incrementItemCount(listId, -1);
  }

  // Update Item Count
  Future<void> incrementItemCount(String listId, int delta) async {
    await databaseConnection
      .collection('groceryLists')
      .doc(listId)
      .update({'itemCount': FieldValue.increment(delta)
    });
  }


  
  //
  // GLOBAL ITEM CATALOG 
  //

  List<String> generateKeywords(String item) {
    item = item.toLowerCase();
    List<String> keywords = [];

    for (int i = 1; i <= item.length; i++) {
      keywords.add(item.substring(0, i));
    }

    return keywords;
  }

  
  
  Future<void> addCatalogItem(CatalogItem item) async {
    await databaseConnection
      .collection('catalog')
      .add(item.toMap());
  }

Stream<List<CatalogItem>> getCatalogItems() {
  return databaseConnection
      .collection('catalog')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => CatalogItem.fromSnapshot(doc)).toList());
}

/*
  Future<List<CatalogItem>> searchCatalog(String query) async {
    final searchQuery = query.toLowerCase();

    final snapshot = await databaseConnection
      .collection('itemsCatalog')
      .where('searchKeywords', arrayContains: searchQuery)
      .limit(10)
      .get();

    return snapshot.docs
      .map((doc) => CatalogItem.fromFirestore(doc))
      .toList();
  }

*/
  

}