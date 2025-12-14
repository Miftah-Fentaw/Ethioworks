import 'package:flutter/material.dart';
import 'package:ethioworks/screens/mobile/job_seeker/job_seeker_home_page.dart';
import 'package:ethioworks/screens/mobile/job_seeker/job_seeker_profile_page.dart';
import 'package:ethioworks/screens/mobile/job_seeker/companies_screen.dart';

class JobSeekerRoot extends StatefulWidget {
  const JobSeekerRoot({super.key});

  @override
  State<JobSeekerRoot> createState() => _JobSeekerRootState();
}

class _JobSeekerRootState extends State<JobSeekerRoot> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    SeekerHomeScreen(),
    SeekerHomeScreen(),
    CompaniesScreen(),
    SeekerProfileScreen(),
  ];

  void _onTap(int idx) => setState(() => _selectedIndex = idx);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Browse'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Companies'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
