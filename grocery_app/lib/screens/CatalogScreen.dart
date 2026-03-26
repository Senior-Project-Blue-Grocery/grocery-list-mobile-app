import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:grocery_app/models/catalog_item.dart';
import 'package:grocery_app/screens/account_screen.dart';
import 'package:grocery_app/screens/aisle_results_screen.dart';
import 'package:grocery_app/screens/aisle_screen.dart';
import 'package:grocery_app/screens/cart_screen.dart';
import 'package:grocery_app/screens/home_screen.dart';
import 'package:grocery_app/screens/item_detail_screen.dart';
import 'package:grocery_app/services/firestore_service.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  int _navIndex = 1;
  String _searchQuery = '';

  final FirestoreService _firestoreService = FirestoreService();

  final List<_Category> categories = const [
    _Category(
      "Dairy &\nEggs",
      "https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400",
    ),
    _Category(
      "Bakery",
      "https://images.unsplash.com/photo-1549931319-a545dcf3bc73?w=400",
    ),
    _Category(
      "Meat &\nSeafood",
      "https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=400",
    ),
    _Category(
      "Beverage",
      "https://images.unsplash.com/photo-1528825871115-3581a5387919?w=400",
    ),
  ];

  String _mapCategoryLabelToQuery(String label) {
    final cleaned = label.toLowerCase().replaceAll('\n', ' ').trim();

    if (cleaned.contains('dairy')) return 'dairy';
    if (cleaned.contains('bakery')) return 'bakery';
    if (cleaned.contains('meat')) return 'meat & seafood';
    if (cleaned.contains('beverage')) return 'drinks';

    return cleaned;
  }

  Future<void> _openAisleScreen() async {
    final selectedAisle = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const AisleScreen()),
    );

    if (selectedAisle != null && selectedAisle.isNotEmpty) {
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AisleResultsScreen(aisle: selectedAisle),
        ),
      );
    }
  }

  void _openItemDetail(CatalogItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ItemDetailScreen(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Item Catalogue Page"),
        elevation: 0,
      ),
      body: StreamBuilder<List<CatalogItem>>(
        stream: _firestoreService.getCatalogItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final allItems = snapshot.data ?? [];

          final filteredItems = allItems.where((item) {
            if (_searchQuery.isEmpty) return true;

            final query = _searchQuery.toLowerCase();

            return item.name.toLowerCase().contains(query) ||
                item.category.toLowerCase().contains(query) ||
                item.keywords.any((k) => k.contains(query));
          }).toList();

          final newProducts = filteredItems.take(10).toList();

          final poultry = filteredItems.where((item) {
            final c = item.category.toLowerCase();
            final n = item.name.toLowerCase();

            return c.contains('meat') ||
                c.contains('seafood') ||
                c.contains('poultry') ||
                n.contains('chicken') ||
                n.contains('turkey');
          }).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            children: [
              _SearchBar(
                hintText: "Search",
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.trim();
                  });
                },
              ),
              const SizedBox(height: 18),
              _SectionHeader(
                title: "Shop by Aisle",
                onTap: _openAisleScreen,
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, i) {
                    final c = categories[i];
                    return _CategoryChip(
                      label: c.label,
                      imageUrl: c.imageUrl,
                      onTap: () {
                        final aisle = _mapCategoryLabelToQuery(c.label);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AisleResultsScreen(aisle: aisle),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              _SectionHeader(
                title: "New Products for you",
                onTap: () {},
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 255,
                child: newProducts.isEmpty
                    ? const Center(child: Text('No items found'))
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: newProducts.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, i) => _ProductCard(
                          item: newProducts[i],
                          onTap: () => _openItemDetail(newProducts[i]),
                        ),
                      ),
              ),
              const SizedBox(height: 24),
              _SectionHeader(
                title: "Poultry",
                onTap: () {},
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 255,
                child: poultry.isEmpty
                    ? const Center(child: Text('No poultry items found'))
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: poultry.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, i) => _ProductCard(
                          item: poultry[i],
                          onTap: () => _openItemDetail(poultry[i]),
                        ),
                      ),
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
        currentIndex: _navIndex,
        onTap: (i) {
          if (i == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else if (i == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CartScreen()),
            );
          } else if (i == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AccountScreen()),
            );
          } else {
            setState(() {
              _navIndex = i;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final CatalogItem item;
  final VoidCallback onTap;

  const _ProductCard({
    required this.item,
    required this.onTap,
  });

  Future<String?> _getImageUrl() async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('catalog_images/${item.name.toLowerCase()}.jpg');

      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(
                aspectRatio: 1,
                child: FutureBuilder<String?>(
                  future: _getImageUrl(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data == null) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported_outlined),
                      );
                    }

                    return Image.network(
                      snapshot.data!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported_outlined),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Category",
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
            Text(
              item.category,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 6),
            const Text(
              "N/A",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;

  const _SearchBar({
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _SectionHeader({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        IconButton(
          onPressed: onTap,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final String imageUrl;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 86,
        child: Column(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundImage: NetworkImage(imageUrl),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Category {
  final String label;
  final String imageUrl;

  const _Category(this.label, this.imageUrl);
}