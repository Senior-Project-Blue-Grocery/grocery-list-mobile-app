import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/models/cart_item.dart';
import 'package:grocery_app/models/grocery_list.dart';
import 'package:grocery_app/services/firestore_service.dart';
import 'package:grocery_app/screens/home_screen.dart';
import 'package:grocery_app/screens/catalogscreen.dart';
import 'package:grocery_app/screens/account_screen.dart';
import 'package:grocery_app/screens/account_linking_screen.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final FirestoreService firestoreService = FirestoreService();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _showAddToListDialog(
    BuildContext context,
    List<GroceryList> lists,
  ) async {
    final Set<String> selectedListIds = {};

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Cart to Lists'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: lists.map((list) {
                    return CheckboxListTile(
                      title: Text(list.name),
                      value: selectedListIds.contains(list.id),
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true) {
                            selectedListIds.add(list.id);
                          } else {
                            selectedListIds.remove(list.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: selectedListIds.isEmpty
                      ? null
                      : () async {
                          if (user != null) {
                            await firestoreService.addCartToMultipleLists(
                              user!.uid,
                              selectedListIds.toList(),
                            );
                          }

                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Cart added to selected lists'),
                              ),
                            );
                          }
                        },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('You must be signed in to use the cart'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: StreamBuilder<List<CartItem>>(
        stream: firestoreService.getCartItems(user!.uid),
        builder: (context, cartSnapshot) {
          if (cartSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!cartSnapshot.hasData || cartSnapshot.data!.isEmpty) {
            return const Center(
              child: Text('Your cart is empty'),
            );
          }

          final cartItems = cartSnapshot.data!;

          final totalPrice = cartItems.fold<double>(
            0,
            (sum, item) => sum + (item.price * item.quantity),
          );

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];

                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: item.imageUrl.isNotEmpty
                            ? Image.network(
                                item.imageUrl,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 48,
                                height: 48,
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.image_not_supported_outlined,
                                ),
                              ),
                      ),
                      title: Text(item.name),
                      subtitle: Text(
                        '${item.category} • Qty: ${item.quantity} • \$${item.price.toStringAsFixed(2)}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await firestoreService.removeCartItem(
                            user!.uid,
                            item.id,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              StreamBuilder<List<GroceryList>>(
                stream: firestoreService.getUserLists(user!.uid),
                builder: (context, listSnapshot) {
                  final lists = listSnapshot.data ?? [];

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: lists.isEmpty
                            ? null
                            : () => _showAddToListDialog(context, lists),
                        child: const Text('Add to a List'),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF2E7DFF),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 28,
        ),
        unselectedIconTheme: const IconThemeData(
          color: Colors.white70,
        ),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 2,
        onTap: (i) {
          if (i == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else if (i == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CatalogScreen()),
            );
          } else if (i == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AccountLinkingScreen(),
              ),
            );
          } else if (i == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AccountScreen()),
            );
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: "",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
      ),
    );
  }
}