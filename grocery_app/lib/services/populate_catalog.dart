import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/models/catalog_item.dart';
import 'package:grocery_app/services/firestore_service.dart';

class PopulateCatalog {
  final FirebaseFirestore databaseConnection = FirebaseFirestore.instance;

  // This is a seeder function to fill the item catalog in our database.
    // It only needs to be ran once; is not needed afterwards.
    Future<void> seedCatalog() async {

      final List<CatalogItem> catalogSeed = [

        //
        // PRODUCE //
        //

        /*
        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 1.25,
          keywords: FirestoreService().generateKeywords('apples'),
          name: 'apples', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fapple.jpg?alt=media&token=564cdf38-aa65-4eea-883e-27fe05e51039'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 0.87,
          keywords: FirestoreService().generateKeywords('avocados'),
          name: 'avocados', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Favocado.jpg?alt=media&token=132ccc1e-26b9-44d9-941e-7d82d7153dc0'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 0.25,
          keywords: FirestoreService().generateKeywords('bananas'),
          name: 'bananas', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fbanana.jpg?alt=media&token=53e48830-6926-4440-b5b0-6a322f70544f'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 1.62,
          keywords: FirestoreService().generateKeywords('bell peppers'),
          name: 'bell peppers', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fbell%20peppers.jpg?alt=media&token=064155e0-6246-45df-a690-25ca48ccdd14'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 5.03,
          keywords: FirestoreService().generateKeywords('blackberries'),
          name: 'blackberries', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fblackberries.jpg?alt=media&token=289ff5f7-60ac-4834-831b-8bba8239d3a2'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 6.13,
          keywords: FirestoreService().generateKeywords('blueberries'),
          name: 'blueberries', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fblueberries.jpg?alt=media&token=236caef5-4fb3-4386-b908-fa9f4af8e1e0'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 1.37,
          keywords: FirestoreService().generateKeywords('broccoli'),
          name: 'broccoli', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fbroccoli.jpg?alt=media&token=3cdf277e-2108-4f3d-a807-2d868b025d1b'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 1.25,
          keywords: FirestoreService().generateKeywords('carrots'),
          name: 'carrots', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fcarrots.jpg?alt=media&token=894ff82c-1f1e-4a58-b23d-c80f2bc41bbb'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 5.03,
          keywords: FirestoreService().generateKeywords('cauliflower'),
          name: 'cauliflower', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fcauliflower.jpg?alt=media&token=2558d086-6d18-4a34-afd4-1e8f02e041ca'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 1.69,
          keywords: FirestoreService().generateKeywords('celery'),
          name: 'celery', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fcelery.jpg?alt=media&token=0fc967b0-a640-48ae-96be-bc36977ef578'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 3.03,
          keywords: FirestoreService().generateKeywords('cherries'),
          name: 'cherries', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fcherries.jpg?alt=media&token=7365558e-3de6-46d0-86ef-cdde6315af18'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 1.37,
          keywords: FirestoreService().generateKeywords('corn'),
          name: 'corn', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fcorn.jpg?alt=media&token=22dbdd0f-99a0-4725-a13d-f8c357bae3e2'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 1.09,
          keywords: FirestoreService().generateKeywords('cucumber'),
          name: 'cucumber', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fcucumber.jpg?alt=media&token=d313015c-ae2a-4c7d-bb19-19331428babd'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 0.66,
          keywords: FirestoreService().generateKeywords('garlic'),
          name: 'garlic', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fgarlic.jpg?alt=media&token=287e0902-8d09-45e4-ae78-c8efb2f1e049'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 3.91,
          keywords: FirestoreService().generateKeywords('grapes'),
          name: 'grapes', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fgrapes.jpg?alt=media&token=c998ee5c-4898-4d8a-8976-6d27d1b23a48'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 3.91,
          keywords: FirestoreService().generateKeywords('green beans'),
          name: 'green beans', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fgreen%20beans.jpg?alt=media&token=3f553d07-067b-4a53-a220-fafa0f41644b'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 0.41,
          keywords: FirestoreService().generateKeywords('jalapenos'),
          name: 'jalapenos', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fjalapenos.jpg?alt=media&token=fb5062a5-06aa-4473-a696-7e94a368b42d'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 0.93,
          keywords: FirestoreService().generateKeywords('kiwis'),
          name: 'kiwis', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fkiwi.jpg?alt=media&token=a623bd0b-4a62-49fc-a1c5-dd5a84abd634'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 0.98,
          keywords: FirestoreService().generateKeywords('lemons'),
          name: 'lemons', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Flemons.jpg?alt=media&token=a50bd5dc-e247-40e2-a4d8-66e92a1cbc2d'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 2.25,
          keywords: FirestoreService().generateKeywords('lettuce'),
          name: 'lettuce', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Flettuce.jpg?alt=media&token=3b2b727c-e154-47b6-9f5b-84ad756ccaa1'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 0.83,
          keywords: FirestoreService().generateKeywords('limes'),
          name: 'limes', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Flimes.jpg?alt=media&token=c495f55c-857d-4d5c-a2e3-b43c3b5b787d'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 1.69,
          keywords: FirestoreService().generateKeywords('mangos'),
          name: 'mangos', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fmango.jpg?alt=media&token=ab70b001-1ae3-4f7f-bbe2-b777c9ecd22b'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 2.25,
          keywords: FirestoreService().generateKeywords('mushrooms'),
          name: 'mushrooms', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fmushrooms.jpg?alt=media&token=ac0310b4-454b-4905-bb45-53c65917d4c3'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 1.25,
          keywords: FirestoreService().generateKeywords('onions'),
          name: 'onions', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fonions.jpg?alt=media&token=010e7550-35f5-4c7c-830e-ed9675cbc62d'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 1.07,
          keywords: FirestoreService().generateKeywords('oranges'),
          name: 'oranges', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Foranges.jpg?alt=media&token=f419d395-8bbc-4627-b260-7763ede7894d'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 2.97,
          keywords: FirestoreService().generateKeywords('peaches'),
          name: 'peaches', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fpeach.jpg?alt=media&token=6b2b00ea-eac1-4228-83ee-22a82cd9dcb7'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 1.06,
          keywords: FirestoreService().generateKeywords('pears'),
          name: 'pears', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fpear.jpg?alt=media&token=357ddbef-ba04-429c-b624-186ea805d64e'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 1.17,
          keywords: FirestoreService().generateKeywords('peas'),
          name: 'peas', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fpeas.jpg?alt=media&token=f2378217-6d0d-4441-ba28-4307f34ecb1b'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 4.31,
          keywords: FirestoreService().generateKeywords('pineapples'),
          name: 'pineapples', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fpineapple.jpg?alt=media&token=2088d675-45fe-4e89-b58f-4646436810c9'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 5.03,
          keywords: FirestoreService().generateKeywords('raspberries'),
          name: 'raspberries', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fraspberries.jpg?alt=media&token=7051679f-a43d-4778-b872-7503922c8baa'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 1.04,
          keywords: FirestoreService().generateKeywords('red onions'),
          name: 'red onions', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fred%20onions.jpg?alt=media&token=db7b4675-9350-4916-a05f-e29790b78f2d'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 4.47,
          keywords: FirestoreService().generateKeywords('spinach'),
          name: 'spinach', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fspinach.jpg?alt=media&token=b73eb608-0f02-4afa-955c-592f1ba967fd'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 4.41,
          keywords: FirestoreService().generateKeywords('strawberries'),
          name: 'strawberries', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fstrawberries.jpg?alt=media&token=c1229bec-6b10-41c5-a29c-983e4a5a5ce8'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 0.99,
          keywords: FirestoreService().generateKeywords('sweet potatoes'),
          name: 'sweet potatoes', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fsweet%20potatoes.jpg?alt=media&token=c9919452-3b56-4107-a7d2-edfcb359af8a'
        ),

        CatalogItem(
          id: '', 
          category: 'produce', 
          price: 4.81,
          keywords: FirestoreService().generateKeywords('watermelon'),
          name: 'watermelon', 
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fwatermelon.jpg?alt=media&token=25c27cd0-c6e6-4ffa-9408-fead5baa3cb0'
        ),

        //
        // DAIRY //
        //

        CatalogItem(
          id: '', 
          name: 'almond milk',
          category: 'dairy', 
          price: 3.31,
          keywords: FirestoreService().generateKeywords('almond milk'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Falmond%20milk.jpg?alt=media&token=43f573b8-7661-4ff3-91e4-e909eb548b13'
        ),

        CatalogItem(
          id: '', 
          name: 'milk',
          category: 'dairy', 
          price: 2.50,
          keywords: FirestoreService().generateKeywords('milk'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fmilk.jpg?alt=media&token=7f1bdcce-d829-461c-a370-36ef5935f472'
        ),

        CatalogItem(
          id: '', 
          name: 'oat milk',
          category: 'dairy', 
          price: 4.09,
          keywords: FirestoreService().generateKeywords('oat milk'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Foatmilk.jpg?alt=media&token=793abb1e-53a3-4207-ab6c-7d0b2a6c8930'
        ),

        CatalogItem(
          id: '', 
          name: 'soy milk',
          category: 'dairy', 
          price: 3.31,
          keywords: FirestoreService().generateKeywords('soy milk'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fsoy%20milk.jpg?alt=media&token=d94687d2-81ab-4b2b-bc4a-a6390d25cc0e'
        ),

        CatalogItem(
          id: '', 
          name: 'butter',
          category: 'dairy', 
          price: 3.37,
          keywords: FirestoreService().generateKeywords('butter'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fbutter.jpg?alt=media&token=5e5be3f1-4a84-486f-ac30-a5c2d7c9a1b3'
        ),

        CatalogItem(
          id: '', 
          name: 'cheddar cheese',
          category: 'dairy', 
          price: 3.03,
          keywords: FirestoreService().generateKeywords('cheddar cheese'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fcheddar%20cheese.jpg?alt=media&token=da9d4c96-4380-4bec-9348-5a4a3fea6efb'
        ),

        CatalogItem(
          id: '', 
          name: 'cream cheese',
          category: 'dairy', 
          price: 2.75,
          keywords: FirestoreService().generateKeywords('cream cheese'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fcream%20cheese.jpg?alt=media&token=36445108-aa8f-42bd-b650-0406b44bd64d'
        ),

        CatalogItem(
          id: '', 
          name: 'ice cream',
          category: 'dairy', 
          price: 4.41,
          keywords: FirestoreService().generateKeywords('ice cream'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fice%20cream.jpg?alt=media&token=d2eddc2c-2e61-43b7-8d24-f30a73a747ee'
        ),

        CatalogItem(
          id: '', 
          name: 'margarine',
          category: 'dairy', 
          price: 3.47,
          keywords: FirestoreService().generateKeywords('margarine'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fmargarine.jpg?alt=media&token=ae6dfa9c-3a07-417b-93ab-88bd0e8d27d5'
        ),

        CatalogItem(
          id: '', 
          name: 'mozzarella',
          category: 'dairy', 
          price: 3.03,
          keywords: FirestoreService().generateKeywords('mozzarella'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fmozzarella.jpg?alt=media&token=a29c1003-ea7e-46e1-b5dd-28c1a52eeab1'
        ),

        CatalogItem(
          id: '', 
          name: 'parmesan',
          category: 'dairy', 
          price: 3.03,
          keywords: FirestoreService().generateKeywords('parmesan'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fparmesan.jpg?alt=media&token=975fe699-3441-4e7e-b69f-88885c839444'
        ),

        CatalogItem(
          id: '', 
          name: 'swiss cheese',
          category: 'dairy', 
          price: 3.03,
          keywords: FirestoreService().generateKeywords('swiss cheese'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fswiss%20cheese.jpg?alt=media&token=9705e165-6dfd-4252-86a6-a15ecb7ff77c'
        ),

        CatalogItem(
          id: '', 
          name: 'yogurt',
          category: 'dairy', 
          price: 0.88,
          keywords: FirestoreService().generateKeywords('yogurt'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fyogurt.jpg?alt=media&token=d157d1e3-bb58-4771-b1d0-998fd862869d'
        ),

        CatalogItem(
          id: '', 
          name: 'apple juice',
          price: 4.47,
          category: 'drinks', 
          keywords: FirestoreService().generateKeywords('apple juice'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fapple%20juice.jpeg?alt=media&token=e91a2c2d-fc32-45e5-80cd-eb3eed99d221'
        ),

        CatalogItem(
          id: '', 
          name: 'bacon',
          price: 8.49,
          category: 'meat & seafood', 
          keywords: FirestoreService().generateKeywords('bacon'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fbacon.jpeg?alt=media&token=e45507a8-7c4d-48d0-b62a-8b85fdcb6f51'
        ),

        CatalogItem(
          id: '', 
          name: 'bagels',
          price: 2.97,
          category: 'bakery', 
          keywords: FirestoreService().generateKeywords('bagels'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fbagels.jpeg?alt=media&token=710884e4-a93c-43a8-aa0a-c55311192db1'
        ),

        CatalogItem(
          id: '', 
          name: 'baking soda',
          price: 1.79,
          category: 'pantry', 
          keywords: FirestoreService().generateKeywords('baking soda'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fbaking%20powder.jpg?alt=media&token=923e334e-d509-46e6-b468-804b2d71e882'
        ),

        CatalogItem(
          id: '', 
          name: 'baking powder',
          price: 2.43,
          category: 'pantry', 
          keywords: FirestoreService().generateKeywords('baking powder'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fbaking%20powder.jpg?alt=media&token=923e334e-d509-46e6-b468-804b2d71e882'
        ),

        CatalogItem(
          id: '', 
          name: 'bbq sauce',
          price: 2.53,
          category: 'condiments', 
          keywords: FirestoreService().generateKeywords('bbq sauce'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fbbq%20sauce.jpeg?alt=media&token=fde96d8a-ccd1-40e2-94db-a538839cba57'
        ),

        CatalogItem(
          id: '', 
          name: 'beef steak',
          price: 17.69,
          category: 'meat & seafood', 
          keywords: FirestoreService().generateKeywords('beef steak'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fbeef%20steak.jpeg?alt=media&token=f8754be3-b2fe-49ac-b22e-469979ddb66a'
        ),

        CatalogItem(
          id: '', 
          name: 'brown rice',
          price: 2.65,
          category: 'pantry', 
          keywords: FirestoreService().generateKeywords('brown rice'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fbrown%20rice.jpeg?alt=media&token=9b3ac85f-a099-4698-a377-b3eef4418f18'
        ),

        CatalogItem(
          id: '', 
          name: 'brown sugar',
          price: 1.93,
          category: 'pantry', 
          keywords: FirestoreService().generateKeywords('brown sugar'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fbrown%20sugar.jpeg?alt=media&token=6bdf4c31-e9b2-4530-97ff-02c08706237f'
        ),

        CatalogItem(
          id: '', 
          name: 'brownies',
          price: 6.31,
          category: 'bakery', 
          keywords: FirestoreService().generateKeywords('brownies'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fbrownies.jpeg?alt=media&token=05bd3955-51f5-4c35-8b95-224bae30831a'
        ),
        */
        
        CatalogItem(
          id: '', 
          name: 'cake',
          price: 25,
          category: 'bakery', 
          keywords: FirestoreService().generateKeywords('cake'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fcake.jpeg?alt=media&token=9b446f19-55ca-47fd-b778-bd507b6ad485'
        ),

        CatalogItem(
          id: '', 
          name: 'cake slice',
          price: 4.41,
          category: 'bakery', 
          keywords: FirestoreService().generateKeywords('cake slice'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fcake%20slice.jpeg?alt=media&token=0fab6def-46a8-4a8d-b8c1-35d4b140cb8a'
        ),

        CatalogItem(
          id: '', 
          name: 'candy',
          price: 5.50,
          category: 'snacks', 
          keywords: FirestoreService().generateKeywords('candy'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fcandy.jpeg?alt=media&token=c23e94c0-3810-4e25-a703-13ebc0a508a4'
        ),

        CatalogItem(
          id: '', 
          name: 'catfish',
          price: 5.30,
          category: 'meat & seafood', 
          keywords: FirestoreService().generateKeywords('catfish'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Ffish.jpeg?alt=media&token=f9235f95-a41a-4a1a-b351-dade3892fc11'
        ),

        CatalogItem(
          id: '', 
          name: 'cereal',
          price: 5.75,
          category: 'pantry', 
          keywords: FirestoreService().generateKeywords('cereal'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fcereal.jpeg?alt=media&token=343825ad-03dd-47a9-b8f0-2d661d2c829a'
        ),

        CatalogItem(
          id: '', 
          name: 'chicken breasts',
          price: 9.43,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('chicken breasts'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fchicken%20breast.jpeg?alt=media&token=2bae7e59-285a-4a79-91c9-bbdc6dc8fa67'
        ),

        CatalogItem(
          id: '', 
          name: 'chicken thighs',
          price: 7.09,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('chicken thighs'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fchicken%20thighs.jpeg?alt=media&token=b7665266-0948-45a3-bd78-905e7285f34a'
        ),

        CatalogItem(
          id: '', 
          name: 'chicken nuggets',
          price: 8.49,
          category: 'frozen', 
          keywords: FirestoreService().generateKeywords('chicken nuggets'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fchicken%20nuggets.jpeg?alt=media&token=5373ecb7-dda2-4cf3-8d77-3057fe5955ce'
        ),

        CatalogItem(
          id: '', 
          name: 'chili powder',
          price: 2.75,
          category: 'spices', 
          keywords: FirestoreService().generateKeywords('chili powder'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fchili%20powder.jpeg?alt=media&token=a900d1ad-f0a8-490a-9579-cd6a131aca35'
        ),

        CatalogItem(
          id: '', 
          name: 'chips',
          price: 5.39,
          category: 'snacks', 
          keywords: FirestoreService().generateKeywords('chips'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fchips.jpeg?alt=media&token=b31f38a1-2683-4c66-836f-142e0c117090'
        ),

        CatalogItem(
          id: '', 
          name: 'chocolate',
          price: 2.21,
          category: 'snacks', 
          keywords: FirestoreService().generateKeywords('chocolate'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fchocolate.jpeg?alt=media&token=e2a41aec-a2f2-45cc-a2bb-c68f5bb645a9'
        ),

        CatalogItem(
          id: '', 
          name: 'cinnamon',
          price: 3.53,
          category: 'spices', 
          keywords: FirestoreService().generateKeywords('cinnamon'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fcinnamon.jpeg?alt=media&token=f85c720f-13bc-4bf9-9180-23b3e3efeb60'
        ),

        CatalogItem(
          id: '', 
          name: 'cod',
          price: 16.59,
          category: 'meat & seafood', 
          keywords: FirestoreService().generateKeywords('cod'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fcod.jpeg?alt=media&token=14b61865-8a69-4098-9f8a-3408d42fa1ad'
        ),

        CatalogItem(
          id: '', 
          name: 'coffee',
          price: 10.99,
          category: 'pantry', 
          keywords: FirestoreService().generateKeywords('coffee'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fcoffee%20beans.jpeg?alt=media&token=83393188-f02a-489f-a1ea-e8fa191dce29'
        ),

        CatalogItem(
          id: '', 
          name: 'cookies',
          price: 6.63,
          category: 'bakery', 
          keywords: FirestoreService().generateKeywords('cookies'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fcookies.jpeg?alt=media&token=334d4c84-a069-411a-a514-122ccf25596e'
        ),

        CatalogItem(
          id: '', 
          name: 'cornstarch',
          price: 1.91,
          category: 'pantry', 
          keywords: FirestoreService().generateKeywords('cornstarch'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fcornstarch.jpeg?alt=media&token=7e7ad378-aed3-4336-bf24-41a24e8555ee'
        ),

        CatalogItem(
          id: '', 
          name: 'cottage cheese',
          price: 4.41,
          category: 'dairy', 
          keywords: FirestoreService().generateKeywords('cottage cheese'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fcottage%20cheese.jpeg?alt=media&token=dcdfba9b-9c97-498a-b899-039a316bb896'
        ),

        
        CatalogItem(
          id: '', 
          name: 'crab legs',
          price: 16.29,
          category: 'meat & seafood', 
          keywords: FirestoreService().generateKeywords('crab legs'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fcrab.jpeg?alt=media&token=347a8f7c-130b-4d54-befc-2f0205487a08'
        ),
        
        CatalogItem(
          id: '', 
          name: 'crackers',
          price: 4.31,
          category: 'snacks', 
          keywords: FirestoreService().generateKeywords('crackers'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fcrackers.jpeg?alt=media&token=f697d994-f057-4a59-8418-b98e917c3964'
        ),

        CatalogItem(
          id: '', 
          name: 'cranberries',
          price: 3.87,
          category: 'produce', 
          keywords: FirestoreService().generateKeywords('cranberries'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fcranberries.jpeg?alt=media&token=33e8b0c6-0e23-4a9e-9c80-c0ffba395530'
        ),
        
        CatalogItem(
          id: '', 
          name: 'croissants',
          price: 7.53,
          category: 'bakery', 
          keywords: FirestoreService().generateKeywords('croissants'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fcroissants.jpeg?alt=media&token=1099d072-f69d-4fcb-ac5e-e114e30a5c38'
        ),

        CatalogItem(
          id: '', 
          name: 'cupcakes',
          price: 6.63,
          category: 'bakery', 
          keywords: FirestoreService().generateKeywords('cupcakes'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fcupcakes.jpeg?alt=media&token=f2ffe68e-181e-47dd-8957-1878d7c0ee65'
        ),
        
        CatalogItem(
          id: '', 
          name: 'dinner rolls',
          price: 5.75,
          category: 'bakery', 
          keywords: FirestoreService().generateKeywords('dinner rolls'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fdinner%20rolls.jpeg?alt=media&token=73a198d5-390c-436d-ab34-b4b9fe30755f'
        ),

        CatalogItem(
          id: '', 
          name: 'donuts',
          price: 5.19,
          category: 'bakery', 
          keywords: FirestoreService().generateKeywords('donuts'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fdonuts.jpeg?alt=media&token=089b93b0-72c9-4d1a-98c5-c70912c2b811'
        ),
        
        CatalogItem(
          id: '', 
          name: 'eggplants',
          price: 3.87,
          category: 'produce', 
          keywords: FirestoreService().generateKeywords('eggplants'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Feggplants.jpeg?alt=media&token=6b93b89e-33d1-4a9a-bc89-03c459b4fb5c'
        ),

        CatalogItem(
          id: '', 
          name: 'energy drinks',
          price: 3.33,
          category: 'drinks', 
          keywords: FirestoreService().generateKeywords('energy drinks'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fenergy%20drinks.jpeg?alt=media&token=72c188d4-527b-4be4-877a-69946a82d7e8'
        ),
        
        CatalogItem(
          id: '', 
          name: 'english muffins',
          price: 5.19,
          category: 'bakery', 
          keywords: FirestoreService().generateKeywords('english muffins'),  
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/grocerylistapp-cd542.firebasestorage.app/o/catalog_images%2Fenglish%20muffins.jpeg?alt=media&token=7b652a10-1649-4d5b-b29e-704d33576788'
        ),

        //
        //
        // ------ CORRECT PRICES STOP HERE ------
        //
        //

        CatalogItem(
          id: '', 
          name: 'fish sticks',
          price: 4.47,
          category: 'frozen', 
          keywords: FirestoreService().generateKeywords('fish sticks'),  
          imageUrl: 'imageUrl'
        ),
        
        CatalogItem(
          id: '', 
          name: 'flour',
          price: 4.47,
          category: 'pantry', 
          keywords: FirestoreService().generateKeywords('flour'),  
          imageUrl: 'imageUrl'
        ),
        
        CatalogItem(
          id: '', 
          name: 'french fries',
          price: 4.47,
          category: 'frozen', 
          keywords: FirestoreService().generateKeywords('french fries'),  
          imageUrl: 'imageUrl'
        ),
        
        CatalogItem(
          id: '', 
          name: 'frozen berries',
          price: 4.47,
          category: 'frozen', 
          keywords: FirestoreService().generateKeywords('frozen berries'),  
          imageUrl: 'imageUrl'
        ),
        
        CatalogItem(
          id: '', 
          name: 'frozen broccoli',
          price: 4.47,
          category: 'frozen', 
          keywords: FirestoreService().generateKeywords('frozen broccoli'),  
          imageUrl: 'imageUrl'
        ),
        
        CatalogItem(
          id: '', 
          name: 'frozen corn',
          price: 4.47,
          category: 'frozen', 
          keywords: FirestoreService().generateKeywords('frozen corn'),  
          imageUrl: 'imageUrl'
        ),
        
        CatalogItem(
          id: '', 
          name: 'frozen peas',
          price: 4.47,
          category: 'frozen', 
          keywords: FirestoreService().generateKeywords('frozen peas'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'frozen pizza',
          price: 4.47,
          category: 'frozen', 
          keywords: FirestoreService().generateKeywords('frozen pizza'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'frozen yogurt',
          price: 4.47,
          category: 'frozen', 
          keywords: FirestoreService().generateKeywords('frozen yogurt'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'garlic powder',
          price: 4.47,
          category: 'spices', 
          keywords: FirestoreService().generateKeywords('garlic powder'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'granola',
          price: 4.47,
          category: 'pantry', 
          keywords: FirestoreService().generateKeywords('granola'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'granola bars',
          price: 4.47,
          category: 'snacks', 
          keywords: FirestoreService().generateKeywords('granola bars'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'greek yogurt',
          price: 4.47,
          category: 'dairy', 
          keywords: FirestoreService().generateKeywords('greek yogurt'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'ground beef',
          price: 4.47,
          category: 'meat & seafood', 
          keywords: FirestoreService().generateKeywords('ground beef'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'ground chicken',
          price: 4.47,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('ground chicken'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'ground turkey',
          price: 4.47,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('ground turkey'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'gum',
          price: 4.47,
          category: 'snacks', 
          keywords: FirestoreService().generateKeywords('gum'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'half and half',
          price: 4.47,
          category: 'dairy', 
          keywords: FirestoreService().generateKeywords('half and half'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'ham',
          price: 4.47,
          category: 'meat & seafood', 
          keywords: FirestoreService().generateKeywords('ham'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'hamburger buns',
          price: 4.47,
          category: 'bakery', 
          keywords: FirestoreService().generateKeywords('hamburger buns'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'heavy cream',
          price: 4.47,
          category: 'dairy', 
          keywords: FirestoreService().generateKeywords('heavy cream'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'honey',
          price: 4.47,
          category: 'pantry', 
          keywords: FirestoreService().generateKeywords('honey'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'hot chocolate',
          price: 4.47,
          category: 'pantry', 
          keywords: FirestoreService().generateKeywords('hot chocolate'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'hot dog buns',
          price: 4.47,
          category: 'bakery', 
          keywords: FirestoreService().generateKeywords('hot dog buns'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'hot sauce',
          price: 4.47,
          category: 'condiments', 
          keywords: FirestoreService().generateKeywords('hot sauce'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'italian seasoning',
          price: 4.47,
          category: 'spices', 
          keywords: FirestoreService().generateKeywords('italian seasoning'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'jasmine rice',
          price: 4.47,
          category: 'pantry', 
          keywords: FirestoreService().generateKeywords('jasmine rice'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'juice',
          price: 4.47,
          category: 'drinks', 
          keywords: FirestoreService().generateKeywords('juice'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'kale',
          price: 4.47,
          category: 'produce', 
          keywords: FirestoreService().generateKeywords('kale'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'ketchup',
          price: 4.47,
          category: 'condiments', 
          keywords: FirestoreService().generateKeywords('ketchup'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'limes',
          price: 4.47,
          category: 'produce', 
          keywords: FirestoreService().generateKeywords('limes'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'lobster',
          price: 4.47,
          category: 'meat & seafood', 
          keywords: FirestoreService().generateKeywords('lobster'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'macaroni',
          price: 4.47,
          category: 'pantry', 
          keywords: FirestoreService().generateKeywords('macaroni'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'maple syrup',
          price: 4.47,
          category: 'pantry', 
          keywords: FirestoreService().generateKeywords('maple syrup'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'mayonnaise',
          price: 4.47,
          category: 'condiments', 
          keywords: FirestoreService().generateKeywords('mayonnaise'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'muffins',
          price: 4.47,
          category: 'bakery', 
          keywords: FirestoreService().generateKeywords('muffins'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'mustard',
          price: 4.47,
          category: 'condiments', 
          keywords: FirestoreService().generateKeywords('mustard'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'nutmeg',
          price: 4.47,
          category: 'spices', 
          keywords: FirestoreService().generateKeywords('nutmeg'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'oatmeal',
          price: 4.47,
          category: 'pantry', 
          keywords: FirestoreService().generateKeywords('oatmeal'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'olive oil',
          price: 4.47,
          category: 'condiments', 
          keywords: FirestoreService().generateKeywords('olive oil'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'onions powder',
          price: 4.47,
          category: 'spices', 
          keywords: FirestoreService().generateKeywords('onion powder'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'orange juice',
          price: 4.47,
          category: 'drinks', 
          keywords: FirestoreService().generateKeywords('orange juice'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'pancakes',
          price: 4.47,
          category: 'frozen', 
          keywords: FirestoreService().generateKeywords('pancakes'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'paprika',
          price: 4.47,
          category: 'spices', 
          keywords: FirestoreService().generateKeywords('paprika'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'pasta',
          price: 4.47,
          category: 'pantry', 
          keywords: FirestoreService().generateKeywords('pasta'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'peanut butter',
          price: 4.47,
          category: 'pantry', 
          keywords: FirestoreService().generateKeywords('peanut butter'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'pepper',
          price: 4.47,
          category: 'spices', 
          keywords: FirestoreService().generateKeywords('pepper'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'chicken breasts',
          price: 4.47,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('chicken breasts'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'chicken breasts',
          price: 4.47,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('chicken breasts'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'chicken breasts',
          price: 4.47,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('chicken breasts'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'chicken breasts',
          price: 4.47,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('chicken breasts'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'chicken breasts',
          price: 4.47,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('chicken breasts'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'chicken breasts',
          price: 4.47,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('chicken breasts'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'chicken breasts',
          price: 4.47,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('chicken breasts'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'chicken breasts',
          price: 4.47,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('chicken breasts'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'chicken breasts',
          price: 4.47,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('chicken breasts'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'chicken breasts',
          price: 4.47,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('chicken breasts'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'chicken breasts',
          price: 4.47,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('chicken breasts'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'chicken breasts',
          price: 4.47,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('chicken breasts'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'chicken breasts',
          price: 4.47,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('chicken breasts'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'chicken breasts',
          price: 4.47,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('chicken breasts'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'chicken breasts',
          price: 4.47,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('chicken breasts'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'chicken breasts',
          price: 4.47,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('chicken breasts'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'chicken breasts',
          price: 4.47,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('chicken breasts'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'chicken breasts',
          price: 4.47,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('chicken breasts'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'chicken breasts',
          price: 4.47,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('chicken breasts'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'chicken breasts',
          price: 4.47,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('chicken breasts'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'chicken breasts',
          price: 4.47,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('chicken breasts'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'chicken breasts',
          price: 4.47,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('chicken breasts'),  
          imageUrl: 'imageUrl'
        ),

        CatalogItem(
          id: '', 
          name: 'chicken breasts',
          price: 4.47,
          category: 'poultry', 
          keywords: FirestoreService().generateKeywords('chicken breasts'),  
          imageUrl: 'imageUrl'
        ),




        
        









      ];

      final firestore = FirebaseFirestore.instance;

        for (var item in catalogSeed) {
          await firestore.collection('catalog').add(item.toMap());
        }


      /*
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
        'whipped cream'
      ];

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
    */
    
    

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


  }

}
  

