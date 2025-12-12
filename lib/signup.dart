// lib/signup_page.dart
import 'package:flutter/material.dart';
import 'signin.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          // LEFT — Sign Up Form
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ETHIOWORKS',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = const LinearGradient(colors: [Color(0xFF0052CC), Color(0xFF00AEEF)]).createShader(const Rect.fromLTWH(0, 0, 300, 70)),
                    ),
                  ),
                  const Text("Ethiopia's #1 Job Platform", style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 40),

                  const Text("Create your account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const Text("Join thousands of professionals today", style: TextStyle(color: Colors.grey)),

                  const SizedBox(height: 30),

                  TextField(
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                  ),

                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0052CC),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Create Account", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white)),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignInPage())),
                      child: const Text.rich(
                        TextSpan(text: "Already have an account? ", children: [
                          TextSpan(text: "Sign in", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0052CC))),
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // RIGHT — Same Hero as Sign In
          if (size.width > 900)
             Expanded(
              flex: 6,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?ixlib=rb-4.0.3&auto=format&fit=crop&q=80',
                    fit: BoxFit.cover,
                  ),
                  ColoredBox(color: Colors.black54),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.work, size: 90, color: Color(0xFFFCDB00)),
                          SizedBox(height: 20),
                          Text(
                            "Find Your Dream Job\nin Ethiopia",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Connect with top companies across the nation.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}