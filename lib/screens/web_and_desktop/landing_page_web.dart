import 'package:ethioworks/widgets/web_landing_page_widgets/landing_page_widgets.dart';
import 'package:ethioworks/widgets/web_landing_page_widgets/web_catehory_landing_page.dart';
import 'package:ethioworks/widgets/web_landing_page_widgets/web_footer_landing_page.dart';
import 'package:ethioworks/widgets/web_landing_page_widgets/web_hero_landing_page.dart';
import 'package:flutter/material.dart';



class LandingPageWeb extends StatelessWidget {
  const LandingPageWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                WebHeroSection(),
                WebStatsSection(),
                WebCategoriesSection(),
                WebProcessSection(),
                WebNewsletterSection(),
                WebFooter(),
              ],
            ),
          ),
          WebNavBar(),
        ],
      ),
    );
  }
}