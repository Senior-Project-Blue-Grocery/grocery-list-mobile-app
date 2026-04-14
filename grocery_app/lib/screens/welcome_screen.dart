import 'package:flutter/material.dart';
import 'package:grocery_app/screens/CatalogScreen.dart';
import 'package:grocery_app/screens/home_screen.dart';
import 'package:grocery_app/services/firestore_service.dart';


/*

Main bottom navigation screen. Will be changed to home/welcome screen later. It is not being used rn.

*/

class ProfileScreen extends StatefulWidget{
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _navIndex = 0;


  FirestoreService firestoreService = FirestoreService();

  final List<Widget> _screens = [
    HomeScreen(),
    CatalogScreen()
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_navIndex],
      // body: Center(child: Text('User Info')),
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
          // Any other icon → just change the selected highlight
          setState(() {
            _navIndex = i;
          });
        },
        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), 
            label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.search), 
            label: "Search"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined), 
            label: "Cart"),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none), 
            label: "Notifications"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), 
            label: "Profile"),
        ],
       ),
    );
  }
}