import 'package:ethioworks/screens/mobile/landing_page.dart';
import 'package:ethioworks/screens/web_and_desktop/landing_page_web.dart';
import 'package:flutter/material.dart';
import 'package:ethioworks/widgets/responsive_layout.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: LandingPageMobile(),
      desktop: LandingPageWeb(),
    );
  }
}




