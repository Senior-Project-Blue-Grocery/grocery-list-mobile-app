import 'package:flutter/material.dart';
import 'package:grocery_app/screens/home_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  int _navIndex = 1;

  // Demo data (replace with your real data / Firestore later)
  final List<_Category> categories = const [
    _Category("Dairy &\nEggs", "https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400"),
    _Category("Bakery", "https://images.unsplash.com/photo-1549931319-a545dcf3bc73?w=400"),
    _Category("Meat &\nSeafood", "https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=400"),
    _Category("Beverage", "https://images.unsplash.com/photo-1528825871115-3581a5387919?w=400"),
  ];

  final List<_Product> newProducts = const [
    _Product(
      brand: "Kettle Brand",
      name: "Avocado Oil Sea Salt",
      price: 4.99,
      size: "6 oz",
      imageUrl: "https://images.unsplash.com/photo-1585238342028-4a0c2b8d0d36?w=500",
    ),
    _Product(
      brand: "Honey Bunches of Oats",
      name: "Maple and Pecans",
      price: 5.99,
      size: "12 oz",
      imageUrl: "https://images.unsplash.com/photo-1585238342074-4549a1f3b6b5?w=500",
    ),
    _Product(
      brand: "V8",
      name: "Energy Drink",
      price: 5.99,
      size: "8 oz",
      imageUrl: "https://images.unsplash.com/photo-1542444459-db63c6b6c84a?w=500",
    ),
  ];

  final List<_Product> poultry = const [
    _Product(
      brand: "Jennie-O",
      name: "Ground Turkey",
      price: 6.49,
      size: "1 lb",
      imageUrl: "https://images.unsplash.com/photo-1604908176997-125f25cc500f?w=500",
    ),
    _Product(
      brand: "Fresh Chicken",
      name: "Chicken Thighs",
      price: 8.99,
      size: "2 lb",
      imageUrl: "https://images.unsplash.com/photo-1604908554162-0f264c8b0c86?w=500",
    ),
    _Product(
      brand: "Organic",
      name: "Chicken Breast",
      price: 10.99,
      size: "2 lb",
      imageUrl: "https://images.unsplash.com/photo-1604908554370-bf15c93dffa8?w=500",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Item Catalogue Page"),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          _SearchBar(
            hintText: "Search",
            onChanged: (value) {
              // Later: filter your products list
            },
          ),
          const SizedBox(height: 18),

          _SectionHeader(
            title: "Shop by Aisle",
            onTap: () {
              // Later: navigate to full categories page
            },
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
                    // Later: open category results
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
            height: 230,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: newProducts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) => _ProductCard(product: newProducts[i]),
            ),
          ),

          const SizedBox(height: 24),
          _SectionHeader(
            title: "Poultry",
            onTap: () {},
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 230,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: poultry.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) => _ProductCard(product: poultry[i]),
            ),
          ),
        ],
      ),

      // Bottom nav like the screenshot
      bottomNavigationBar: BottomNavigationBar(
  backgroundColor: const Color(0xFF2E7DFF),

  // THIS is the real fix
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
    // Home button → go to HomeScreen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  } else {
    // Any other icon → just change the selected highlight
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
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: SizedBox(
        width: 86,
        child: Column(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: NetworkImage(imageUrl),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final _Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: AspectRatio(
              aspectRatio: 1, // square-ish
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported_outlined),
                      ),
                    ),
                  ),
                  // Size tag like "12 oz"
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        product.size,
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Brand",
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
          Text(
            product.brand,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            "\$${product.price.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _Category {
  final String label;
  final String imageUrl;
  const _Category(this.label, this.imageUrl);
}

class _Product {
  final String brand;
  final String name;
  final double price;
  final String size;
  final String imageUrl;

  const _Product({
    required this.brand,
    required this.name,
    required this.price,
    required this.size,
    required this.imageUrl,
  });
}