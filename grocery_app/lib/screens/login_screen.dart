import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_app/screens/register_screen.dart';
import 'home_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// Firebase instance
final FirebaseAuth _auth = FirebaseAuth.instance;


class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String errorMessage = '';

  Future<void> signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim()
        );


        // Navigate to home screen after login
        if (mounted) {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
        }

    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Login failed';
      });
    }
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      backgroundColor: Colors.blue[50],
      body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_cart, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                "Grocery List",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 40),

              TextField(
                controller: emailController, decoration: const InputDecoration(labelText: "Email")),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController, 
                obscureText: true, 
                decoration: const InputDecoration(labelText: "Password")),
              const SizedBox(height: 24),

              if (errorMessage.isNotEmpty) 
                Text(errorMessage, style: const TextStyle(color: Colors.red)),
              
              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: signIn, 
                child: const Text("Login")
                ),

              TextButton(
                onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (builder) => RegisterScreen()),
                  );
              }, child: const Text("Create account")),

              ElevatedButton(
                onPressed: () => FirebaseAuth.instance.signOut(), 
                child: const Text('Logout'),
                )
            ],
        ),
      ),
    );
  }
}

