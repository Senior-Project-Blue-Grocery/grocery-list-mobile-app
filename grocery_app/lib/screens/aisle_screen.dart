import 'package:flutter/material.dart';

class AisleScreen extends StatelessWidget {
  const AisleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final aisles = const [
      'produce',
      'dairy',
      'bakery',
      'meat & seafood',
      'drinks',
      'snacks',
      'frozen',
      'pantry',
      'condiments',
      'spices',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop by Aisle"),
      ),
      body: ListView.builder(
        itemCount: aisles.length,
        itemBuilder: (context, index) {
          final aisle = aisles[index];

          return ListTile(
            title: Text(_formatTitle(aisle)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pop(context, aisle);
            },
          );
        },
      ),
    );
  }

  String _formatTitle(String value) {
    return value
        .split(' ')
        .map((word) =>
            word.isEmpty ? word : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}