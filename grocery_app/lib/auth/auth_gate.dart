import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/screens/home_screen.dart';
import 'package:grocery_app/screens/login_screen.dart';

// This widget listens to Firebase authentication state
// and automatically routes the user to the correct screen.
// HOME SCREEN if logged in
// LOGIN SCREEN if logged out

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // While Firebase is checking login state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If user is logged in → go to HomeScreen
        if (snapshot.hasData /*&& snapshot.data != null*/) {
            return const HomeScreen();
        } else {
            // Otherwise → show LoginScreen
            return const LoginScreen();
        }
      },
    );
  }
}

