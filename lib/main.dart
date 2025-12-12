// lib/main.dart
import 'package:flutter/material.dart';
import 'utils/platform_checker.dart';
import 'screens/web_and_desktop/auth/signin.dart' as web_auth;

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
      home: const Launcher(),
    );
  }
}

class Launcher extends StatelessWidget {
  const Launcher({super.key});

  @override
  Widget build(BuildContext context) {
    final platform = PlatformChecker.detectPlatform();

    switch (platform) {
      case AppPlatform.webAndDesktop:
        return const web_auth.SignInPage();
      case AppPlatform.mobile:
        return const web_auth.SignInPage();
    }
  }
}