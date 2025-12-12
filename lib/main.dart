// lib/main.dart
import 'package:flutter/material.dart';
import 'signin.dart';
import 'signup.dart';

void main() {
  runApp(const EthioWorksApp());
}

class EthioWorksApp extends StatelessWidget {
  const EthioWorksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ETHIOWORKS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
      home: const SignInPage(), 
    );
  }
}