import 'package:ethioworks/screens/web_and_desktop/employer/employer_root.dart';
import 'package:ethioworks/screens/web_and_desktop/job_seeker/job_seeker_root.dart';
import 'package:ethioworks/screens/web_and_desktop/auth/signin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/providers/auth_provider.dart';
import 'package:ethioworks/theme.dart';

class WebSplashScreen extends StatefulWidget {
  const WebSplashScreen({super.key});

  @override
  State<WebSplashScreen> createState() => _WebSplashScreenState();
}

class _WebSplashScreenState extends State<WebSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.checkAuthStatus();

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (authProvider.isLoggedIn) {
      if (authProvider.isJobSeeker) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const JobSeekerRoot()));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const EmployerRoot()));
      }
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const WebLoginScreen()));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1519389951296-93c8e892a2e3?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80', // Modern Ethiopian/African business scene
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.4),
            colorBlendMode: BlendMode.darken,
          ),
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.work_rounded, size: 120, color: Colors.white),
                  const SizedBox(height: 40),
                  Text(
                    'EthioWorks',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 56,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Connect • Opportunity • Growth',
                    style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}