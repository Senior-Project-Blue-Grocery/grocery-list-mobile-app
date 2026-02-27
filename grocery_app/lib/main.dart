import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grocery_app/auth/auth_gate.dart';
import 'package:grocery_app/screens/home_screen.dart';
import 'package:grocery_app/screens/login_screen.dart';
import 'package:grocery_app/screens/CatalogScreen.dart';
import 'firebase_options.dart';


// Initialize Firebase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const GroceryApp());
}


class GroceryApp extends StatelessWidget {
  const GroceryApp({super.key});


  /// root of application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grocery List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const AuthGate(),
      home: const LoginScreen(),
    );
  }
}



