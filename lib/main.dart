import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/providers/auth_provider.dart';
import 'package:ethioworks/providers/job_provider.dart';
import 'package:ethioworks/providers/application_provider.dart';
import 'package:ethioworks/screens/mobile/auth/splash.dart';
import 'package:ethioworks/screens/web_and_desktop/auth/splash.dart' as web_splash;
import 'package:ethioworks/utils/platform_checker.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => JobProvider()),
        ChangeNotifierProvider(create: (_) => ApplicationProvider()),
      ],
      child: MaterialApp(
        title: 'EthioWorks - Job Connection Platform',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: PlatformChecker.detectPlatform() == AppPlatform.mobile
            ? const SplashScreen()
            : const web_splash.WebSplashScreen(),
      ),
    );
  }
}
