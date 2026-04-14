import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_app/models/catalog_item.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/models/grocery_list.dart';
import 'package:grocery_app/models/user_model.dart';
import 'package:grocery_app/models/cart_item.dart';

class FirestoreService {
  
  final FirebaseFirestore databaseConnection = FirebaseFirestore.instance;

  //
  // LOGIN & LOGOUT
  //

  // FirebaseAuth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signIn(String email, String password) async {
    
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    
  }
  Future<void> signOut() async {
    await _auth.signOut();
  }

  //
  // USERS
  //

  // register user account and add them to the database
  Future<void> registerUser(String email, String password, UserModel user) async {
    // Create Firebase Auth user
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, 
        password: password
    );

    final uid = FirebaseAuth.instance.currentUser?.uid;

    await databaseConnection.collection('users').doc(uid).set(user.toMap());
    
  }


  //
  // GROCERY LISTS FUNCTIONS
  //

  // create new list
  Future<void> createList(GroceryList list) async {
    final docRef = databaseConnection.collection('groceryLists').doc();

    final newList = GroceryList(
      id: docRef.id,
      name: list.name,
      ownerId: list.ownerId,
      sharedWith: [],
      itemCount: list.itemCount,
      createdAt: Timestamp.now()
    );

    await docRef.set(newList.toMap());
  }

  // show user's lists
  Stream<List<GroceryList>> getUserLists(String userId) {
    return databaseConnection
        .collection('groceryLists')
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => GroceryList.fromFirestore(doc)).toList());
  }

  // delete list
  Future<void> deleteList(String listId) async {
    await databaseConnection.collection('groceryLists').doc(listId).delete();
  }

  
  //
  // SHARING FUNCTIONS
  //

  Future<void> shareList(String listId, String userId) async {
    await databaseConnection.collection('groceryLists').doc(listId).update({
      'sharedWith': FieldValue.arrayUnion([userId])
    });
  }

  Future<void> unshareList(String listId, String userId) async {
    await databaseConnection.collection('groceryLists').doc(listId).update({
      'sharedWith': FieldValue.arrayRemove([userId])
    });
  }

  Future<bool> userHasAccess(String listId, String userId) async {
    final doc = await databaseConnection.collection('groceryLists').doc(listId).get();

    if (!doc.exists) return false;

    final data = doc.data() as Map<String, dynamic>;
    final ownerId = data['ownerId'];
    final shared = List<String>.from(data['sharedWith'] ?? []);

    return ownerId == userId || shared.contains(userId);
  }

  //
  // ITEMS IN A LIST FUNCTIONS
  //

  // add an item to a list
  Future<void> addItem(String userId, String listId, GroceryItem item) async {
    await databaseConnection
        .collection('groceryLists')
        .doc(listId)
        .collection('items')
        .add(item.toMap());

    await incrementItemCount(listId, 1);
  }

  // listen to items in list, updates automatically
  Stream<List<GroceryItem>> getItems(String listId) {
    return databaseConnection
        .collection('groceryLists')
        .doc(listId)
        .collection('items')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => GroceryItem.fromFirestore(doc)).toList());
  }

  // mark item completed or not
  Future<void> toggleItem(String listId, String itemId, bool value) async {
    // need to check if completed value is true or false
    await databaseConnection
        .collection('groceryLists')
        .doc(listId)
        .collection('items')
        .doc(itemId)
        .update({'completed': value});
  }

  // delete item from list
  Future<void> deleteItem(String listId, String itemId) async {
    await databaseConnection
        .collection('groceryLists')
        .doc(listId)
        .collection('items')
        .doc(itemId)
        .delete();

    await incrementItemCount(listId, -1);
  }

  // update item count
  Future<void> incrementItemCount(String listId, int delta) async {
    await databaseConnection
        .collection('groceryLists')
        .doc(listId)
        .update({
      'itemCount': FieldValue.increment(delta),
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
    final docId = item.name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');

    await databaseConnection
        .collection('catalog')
        .doc(docId)
        .set(item.toMap());
  }

  Stream<List<CatalogItem>> getCatalogItems() {
    return databaseConnection
        .collection('catalog')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CatalogItem.fromSnapshot(doc))
            .toList());
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

  //
  // CART FUNCTIONS
  //

  Future<void> addToCart(String userId, CartItem item) async {
    final cartRef = databaseConnection
        .collection('users')
        .doc(userId)
        .collection('cart');

    final existing = await cartRef
        .where('name', isEqualTo: item.name)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      final doc = existing.docs.first;
      final currentQty = (doc.data()['quantity'] ?? 1) as int;

      await cartRef.doc(doc.id).update({
        'quantity': currentQty + item.quantity,
      });
    } else {
      await cartRef.add(item.toMap());
    }
  }

  Stream<List<CartItem>> getCartItems(String userId) {
    return databaseConnection
        .collection('users')
        .doc(userId)
        .collection('cart')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => CartItem.fromFirestore(doc)).toList());
  }

  Future<void> removeCartItem(String userId, String cartItemId) async {
    await databaseConnection
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(cartItemId)
        .delete();
  }

  Future<void> clearCart(String userId) async {
    final snapshot = await databaseConnection
        .collection('users')
        .doc(userId)
        .collection('cart')
        .get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> addCartToList(String userId, String listId) async {
    final cartSnapshot = await databaseConnection
        .collection('users')
        .doc(userId)
        .collection('cart')
        .get();

    if (cartSnapshot.docs.isEmpty) return;

    int totalItems = 0;

    for (final doc in cartSnapshot.docs) {
      final cartItem = CartItem.fromFirestore(doc);

      await databaseConnection
          .collection('groceryLists')
          .doc(listId)
          .collection('items')
          .add({
        'name': cartItem.name,
        'quantity': cartItem.quantity,
        'completed': false,
      });

      totalItems += cartItem.quantity;
    }

    await incrementItemCount(listId, totalItems);
    await clearCart(userId);
  }
}