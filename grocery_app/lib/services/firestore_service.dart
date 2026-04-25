import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/models/catalog_item.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/models/grocery_list.dart';
import 'package:grocery_app/models/cart_item.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreService {
  final FirebaseFirestore databaseConnection = FirebaseFirestore.instance;

  //
  // GROCERY LISTS FUNCTIONS
  //

  Future<void> createList(GroceryList list) async {
    final docRef = databaseConnection.collection('groceryLists').doc();

    final newList = GroceryList(
      id: docRef.id,
      name: list.name,
      ownerId: list.ownerId,
      sharedWith: [],
      itemCount: list.itemCount,
    );

    await docRef.set(newList.toMap());
  }

  Stream<List<GroceryList>> getOwnedLists(String userId) {
    return databaseConnection
        .collection('groceryLists')
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => GroceryList.fromFirestore(doc)).toList());
  }

  Stream<List<GroceryList>> getSharedLists(String userId) {
    return databaseConnection
        .collection('groceryLists')
        .where('sharedWith', arrayContains: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => GroceryList.fromFirestore(doc)).toList());
  }

  Stream<List<GroceryList>> getUserLists(String userId) {
    return Rx.combineLatest2<List<GroceryList>, List<GroceryList>,
        List<GroceryList>>(
      getOwnedLists(userId),
      getSharedLists(userId),
      (ownedLists, sharedLists) {
        final Map<String, GroceryList> mergedLists = {};

        for (final list in ownedLists) {
          mergedLists[list.id] = list;
        }

        for (final list in sharedLists) {
          mergedLists[list.id] = list;
        }

        final result = mergedLists.values.toList();

        result.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );

        return result;
      },
    );
  }

  Future<void> deleteList(String listId) async {
    await databaseConnection.collection('groceryLists').doc(listId).delete();
  }

  Future<void> leaveSharedList(String listId, String userId) async {
    await databaseConnection.collection('groceryLists').doc(listId).update({
      'sharedWith': FieldValue.arrayRemove([userId]),
    });
  }

  Future<void> removeUserFromList(String listId, String userId) async {
    await databaseConnection.collection('groceryLists').doc(listId).update({
      'sharedWith': FieldValue.arrayRemove([userId]),
    });
  }

  //
  // LIST INVITE FUNCTIONS
  //

  Future<void> sendInvite({
    required String listId,
    required String listName,
    required String ownerId,
    required String invitedUserId,
  }) async {
    await databaseConnection.collection('listInvites').add({
      'listId': listId,
      'listName': listName,
      'ownerId': ownerId,
      'invitedUserId': invitedUserId,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getPendingInvites(String userId) {
    return databaseConnection
        .collection('listInvites')
        .where('invitedUserId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  Future<void> acceptInvite({
    required String inviteId,
    required String listId,
    required String userId,
  }) async {
    final batch = databaseConnection.batch();

    final listRef = databaseConnection.collection('groceryLists').doc(listId);
    final inviteRef =
        databaseConnection.collection('listInvites').doc(inviteId);

    batch.update(listRef, {
      'sharedWith': FieldValue.arrayUnion([userId]),
    });

    batch.update(inviteRef, {
      'status': 'accepted',
      'respondedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  Future<void> declineInvite(String inviteId) async {
    await databaseConnection.collection('listInvites').doc(inviteId).update({
      'status': 'declined',
      'respondedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<String?> getUserIdByEmail(String email) async {
    final snapshot = await databaseConnection
        .collection('users')
        .where('email', isEqualTo: email.trim().toLowerCase())
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return snapshot.docs.first.id;
  }

  Future<Map<String, dynamic>?> getUserById(String userId) async {
    final doc = await databaseConnection.collection('users').doc(userId).get();

    if (!doc.exists) return null;
    return doc.data();
  }

  Future<List<Map<String, dynamic>>> getUsersByIds(List<String> userIds) async {
    List<Map<String, dynamic>> users = [];

    for (final uid in userIds) {
      final doc = await databaseConnection.collection('users').doc(uid).get();

      if (doc.exists && doc.data() != null) {
        users.add({
          'uid': uid,
          ...doc.data()!,
        });
      }
    }

    return users;
  }

  //
  // ITEMS IN A LIST FUNCTIONS
  //

  Future<void> addItem(String userId, String listId, GroceryItem item) async {
    await databaseConnection
        .collection('groceryLists')
        .doc(listId)
        .collection('items')
        .add(item.toMap());

    await incrementItemCount(listId, 1);
  }

  Stream<List<GroceryItem>> getItems(String listId) {
    return databaseConnection
        .collection('groceryLists')
        .doc(listId)
        .collection('items')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => GroceryItem.fromFirestore(doc)).toList());
  }

  Future<void> toggleItem(String listId, String itemId, bool value) async {
    await databaseConnection
        .collection('groceryLists')
        .doc(listId)
        .collection('items')
        .doc(itemId)
        .update({'completed': value});
  }

  Future<void> deleteItem(String listId, String itemId) async {
    await databaseConnection
        .collection('groceryLists')
        .doc(listId)
        .collection('items')
        .doc(itemId)
        .delete();

    await incrementItemCount(listId, -1);
  }

  Future<void> incrementItemCount(String listId, int delta) async {
    await databaseConnection.collection('groceryLists').doc(listId).update({
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

    await databaseConnection.collection('catalog').doc(docId).set(item.toMap());
  }

  Stream<List<CatalogItem>> getCatalogItems() {
    return databaseConnection.collection('catalog').snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => CatalogItem.fromSnapshot(doc)).toList(),
        );
  }

  //
  // CART FUNCTIONS
  //

  Future<void> addToCart(String userId, CartItem item) async {
    final cartRef = databaseConnection
        .collection('users')
        .doc(userId)
        .collection('cart');

    final existing =
        await cartRef.where('name', isEqualTo: item.name).limit(1).get();

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
        'imageUrl': cartItem.imageUrl,
        'price': cartItem.price,
      });

      totalItems += cartItem.quantity;
    }

    await incrementItemCount(listId, totalItems);
    await clearCart(userId);
  }

  Future<void> addCartToMultipleLists(
    String userId,
    List<String> listIds,
  ) async {
    final cartSnapshot = await databaseConnection
        .collection('users')
        .doc(userId)
        .collection('cart')
        .get();

    if (cartSnapshot.docs.isEmpty || listIds.isEmpty) return;

    for (final listId in listIds) {
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
          'imageUrl': cartItem.imageUrl,
          'price': cartItem.price,
        });

        totalItems += cartItem.quantity;
      }

      await incrementItemCount(listId, totalItems);
    }

    await clearCart(userId);
  }
}