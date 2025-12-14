import 'package:flutter/material.dart';
import 'package:ethioworks/screens/mobile/employer/employer_home_page.dart';
import 'package:ethioworks/screens/mobile/employer/post_job_page.dart';
import 'package:ethioworks/screens/mobile/employer/all_applicants_screen.dart';
import 'package:ethioworks/screens/mobile/employer/employer_profile_page.dart';

class EmployerRoot extends StatefulWidget {
  const EmployerRoot({super.key});

  @override
  State<EmployerRoot> createState() => _EmployerRootState();
}

class _EmployerRootState extends State<EmployerRoot> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    EmployerHomeScreen(),
    PostJobScreen(),
    AllApplicantsScreen(),
    EmployerProfileScreen(),
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
          BottomNavigationBarItem(icon: Icon(Icons.post_add), label: 'Post Job'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Applicants'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
