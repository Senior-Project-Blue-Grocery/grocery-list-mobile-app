import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/models/catalog_item.dart';

class PopulateCatalog {
  final FirebaseFirestore databaseConnection = FirebaseFirestore.instance;

  // This is a seeder function to fill the item catalog in our database.
  // It only needs to be run once and is not needed afterwards.
  Future<void> seedCatalog() async {
    List<String> produce = [
      'apples',
      'bananas',
      'oranges',
      'strawberries',
      'blueberries',
      'raspberries',
      'blackberries',
      'grapes',
      'pineapple',
      'mango',
      'peaches',
      'pears',
      'watermelon',
      'cantaloupe',
      'kiwi',
      'lemons',
      'limes',
      'avocado',
      'pomegranate',
      'cranberries',
      'cherries',
      'lettuce',
      'spinach',
      'kale',
      'broccoli',
      'cauliflower',
      'carrots',
      'celery',
      'cucumber',
      'zucchini',
      'eggplant',
      'bell peppers',
      'jalapenos',
      'onions',
      'red onions',
      'garlic',
      'green beans',
      'peas',
      'corn',
      'sweet potatoes',
      'mushrooms',
    ];

    for (var item in produce) {
      try {
        await addCatalogItem(
          CatalogItem(
            id: '',
            category: 'produce',
            keywords: generateKeywords(item),
            name: item,
            price: 0,
            imageUrl: '',
          ),
        );

        log('Added $item');
      } catch (e) {
        log('Error adding $item: $e');
      }
    }

    List<String> dairy = [
      'milk',
      'almond milk',
      'soy milk',
      'oat milk',
      'butter',
      'margarine',
      'cheddar cheese',
      'mozzarella',
      'parmesan',
      'swiss cheese',
      'cream cheese',
      'cottage cheese',
      'yogurt',
      'greek yogurt',
      'heavy cream',
      'half and half',
      'sour cream',
      'ice cream',
      'frozen yogurt',
      'whipped cream',
    ];

    for (var item in dairy) {
      await addCatalogItem(
        CatalogItem(
          id: '',
          category: 'dairy',
          keywords: generateKeywords(item),
          name: item,
          price: 0,
          imageUrl: '',
        ),
      );
    }

    List<String> meatAndSeafood = [
      'chicken breast',
      'chicken thighs',
      'ground chicken',
      'ground turkey',
      'ground beef',
      'beef steak',
      'pork chops',
      'bacon',
      'sausage',
      'ham',
      'turkey',
      'salmon',
      'tuna',
      'shrimp',
      'crab',
      'lobster',
      'tilapia',
      'cod',
      'catfish',
      'scallops',
    ];

    for (var item in meatAndSeafood) {
      await addCatalogItem(
        CatalogItem(
          id: '',
          category: 'meat & seafood',
          keywords: generateKeywords(item),
          name: item,
          price: 0,
          imageUrl: '',
        ),
      );
    }

    List<String> bakery = [
      'white bread',
      'wheat bread',
      'sourdough bread',
      'bagels',
      'english muffins',
      'hamburger buns',
      'hot dog buns',
      'croissants',
      'muffins',
      'pancakes',
      'waffles',
      'tortillas',
      'pita bread',
      'donuts',
      'cupcakes',
      'cake',
      'brownies',
      'cookies',
      'pie crust',
      'dinner rolls',
    ];

    for (var item in bakery) {
      await addCatalogItem(
        CatalogItem(
          id: '',
          category: 'bakery',
          keywords: generateKeywords(item),
          name: item,
          price: 0,
          imageUrl: '',
        ),
      );
    }

    List<String> pantry = [
      'white rice',
      'brown rice',
      'jasmine rice',
      'quinoa',
      'pasta',
      'spaghetti',
      'macaroni',
      'ramen noodles',
      'oatmeal',
      'cereal',
      'granola',
      'flour',
      'sugar',
      'brown sugar',
      'powdered sugar',
      'baking soda',
      'baking powder',
      'cornstarch',
      'honey',
      'maple syrup',
      'peanut butter',
    ];

    for (var item in pantry) {
      await addCatalogItem(
        CatalogItem(
          id: '',
          category: 'pantry',
          keywords: generateKeywords(item),
          name: item,
          price: 0,
          imageUrl: '',
        ),
      );
    }

    List<String> condiments = [
      'ketchup',
      'mustard',
      'mayonnaise',
      'bbq sauce',
      'soy sauce',
      'teriyaki sauce',
      'hot sauce',
      'vinegar',
      'olive oil',
      'vegetable oil',
      'sesame oil',
    ];

    for (var item in condiments) {
      await addCatalogItem(
        CatalogItem(
          id: '',
          category: 'condiments',
          keywords: generateKeywords(item),
          name: item,
          price: 0,
          imageUrl: '',
        ),
      );
    }

    List<String> spices = [
      'salt',
      'pepper',
      'garlic powder',
      'onion powder',
      'paprika',
      'cinnamon',
      'nutmeg',
      'italian seasoning',
      'chili powder',
    ];

    for (var item in spices) {
      await addCatalogItem(
        CatalogItem(
          id: '',
          category: 'spices',
          keywords: generateKeywords(item),
          name: item,
          price: 0,
          imageUrl: '',
        ),
      );
    }

    List<String> frozen = [
      'frozen pizza',
      'frozen broccoli',
      'frozen corn',
      'frozen peas',
      'frozen berries',
      'waffles',
      'pancakes',
      'french fries',
      'tater tots',
      'chicken nuggets',
      'fish sticks',
      'shrimp',
      'ice cream',
      'popsicles',
    ];

    for (var item in frozen) {
      await addCatalogItem(
        CatalogItem(
          id: '',
          category: 'frozen',
          keywords: generateKeywords(item),
          name: item,
          price: 0,
          imageUrl: '',
        ),
      );
    }

    List<String> snacks = [
      'chips',
      'pretzels',
      'popcorn',
      'crackers',
      'granola bars',
      'protein bars',
      'trail mix',
      'chocolate',
      'candy',
      'gum',
    ];

    for (var item in snacks) {
      await addCatalogItem(
        CatalogItem(
          id: '',
          category: 'snacks',
          keywords: generateKeywords(item),
          name: item,
          price: 0,
          imageUrl: '',
        ),
      );
    }

    List<String> drinks = [
      'soda',
      'sparkling water',
      'water',
      'juice',
      'apple juice',
      'orange juice',
      'energy drinks',
      'sports drinks',
      'coffee',
      'tea',
      'hot chocolate',
    ];

    for (var item in drinks) {
      await addCatalogItem(
        CatalogItem(
          id: '',
          category: 'drinks',
          keywords: generateKeywords(item),
          name: item,
          price: 0,
          imageUrl: '',
        ),
      );
    }
  }

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
}