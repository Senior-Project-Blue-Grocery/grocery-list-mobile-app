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

  // create new list
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

  // show lists user owns
  Stream<List<GroceryList>> getOwnedLists(String userId) {
    return databaseConnection
        .collection('groceryLists')
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => GroceryList.fromFirestore(doc)).toList());
  }

  // show lists shared with user
  Stream<List<GroceryList>> getSharedLists(String userId) {
    return databaseConnection
        .collection('groceryLists')
        .where('sharedWith', arrayContains: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => GroceryList.fromFirestore(doc)).toList());
  }

  // show all lists user has access to
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

  // delete list
  Future<void> deleteList(String listId) async {
    await databaseConnection.collection('groceryLists').doc(listId).delete();
  }

  //
  // LIST INVITE FUNCTIONS
  //

  // send invite
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

  // get pending invites for a user
  Stream<QuerySnapshot> getPendingInvites(String userId) {
    return databaseConnection
        .collection('listInvites')
        .where('invitedUserId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  // accept invite
  Future<void> acceptInvite({
    required String inviteId,
    required String listId,
    required String userId,
  }) async {
    final batch = databaseConnection.batch();

    final listRef = databaseConnection.collection('groceryLists').doc(listId);
    final inviteRef = databaseConnection.collection('listInvites').doc(inviteId);

    batch.update(listRef, {
      'sharedWith': FieldValue.arrayUnion([userId]),
    });

    batch.update(inviteRef, {
      'status': 'accepted',
      'respondedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  // decline invite
  Future<void> declineInvite(String inviteId) async {
    await databaseConnection.collection('listInvites').doc(inviteId).update({
      'status': 'declined',
      'respondedAt': FieldValue.serverTimestamp(),
    });
  }

  // get UID from email
  Future<String?> getUserIdByEmail(String email) async {
    final snapshot = await databaseConnection
        .collection('users')
        .where('email', isEqualTo: email.trim().toLowerCase())
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return snapshot.docs.first.id;
  }

  /*
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
  */

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
          (snapshot) => snapshot.docs
              .map((doc) => CatalogItem.fromSnapshot(doc))
              .toList(),
        );
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
      });

      totalItems += cartItem.quantity;
    }

    await incrementItemCount(listId, totalItems);
    await clearCart(userId);
  }
}