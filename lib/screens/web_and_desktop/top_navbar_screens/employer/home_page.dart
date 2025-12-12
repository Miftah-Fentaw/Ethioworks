import 'package:ethioworks/screens/web_and_desktop/top_navbar_screens/employer/ana;ytics_page.dart';
import 'package:ethioworks/screens/web_and_desktop/top_navbar_screens/employer/dashboard_page.dart';
import 'package:ethioworks/screens/web_and_desktop/top_navbar_screens/employer/post_jobs_page.dart';
import 'package:ethioworks/screens/web_and_desktop/top_navbar_screens/employer/profile_page.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    DashboardPage(),
    PostJobsPage(),
    AnalyticsPage(),
    ProfilePage(),
  ];

  final List<String> pageTitles = [
    "Home",
    "Post Jobs",
    "Analytics",
    "Profile",
  ];


  @override
  Widget build(BuildContext context) {
   final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        // Sidebar
        Container(
          width: 250,
          color: Colors.white,
          padding:  EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'EthioWorks',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(width: 15),
                    Icon(Icons.dark_mode),
                    
                  ],
                )
              ),
              const SizedBox(height: 40),
              _sidebarItem("Home", Icons.home, 0),
              _sidebarItem("Post New Job", Icons.work, 1),
              _sidebarItem("Analytics", Icons.bar_chart, 2),
              _sidebarItem("Profile", Icons.person, 3),
            ],
          ),
        ),

        // Main Content
        Expanded(
          child: Container(
            color: Colors.grey[100],
            child: Column(
              children: [
                // Top Bar
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 6),
                    ],
                  ),
                  child: Center(
                      child: Text(
                        pageTitles[selectedIndex],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    
                  ),
                ),

                // Page Body
                Expanded(child: pages[selectedIndex]),
              ],
            ),
          ),
        ),
      ],
    );
  }
Widget _sidebarItem(String title, IconData icon, int index) {
  final bool active = selectedIndex == index;
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
        decoration: BoxDecoration(
          color: active ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          border: active
              ? const Border(
                  left: BorderSide(color: Colors.blue, width: 4),
                )
              : null,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon, color: active ? Colors.blue : Colors.black54),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: active ? FontWeight.bold : FontWeight.w500,
                color: active ? Colors.blue : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}