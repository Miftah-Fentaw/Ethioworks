import 'package:ethioworks/screens/mobile/employer/employer_home_page.dart';
import 'package:ethioworks/screens/mobile/employer/post_job_page.dart';
import 'package:ethioworks/screens/mobile/employer/all_applicants_screen.dart';
import 'package:ethioworks/screens/mobile/employer/employer_profile_page.dart';
import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outline,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: theme.colorScheme.surface,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: theme.colorScheme.onSurfaceVariant,
          selectedLabelStyle: theme.textTheme.labelSmall
              ?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 0.5),
          unselectedLabelStyle: theme.textTheme.labelSmall
              ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.5),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              activeIcon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_rounded),
              activeIcon: Icon(Icons.add_box_rounded),
              label: 'POST',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_rounded),
              activeIcon: Icon(Icons.people_alt_rounded),
              label: 'APPLICANTS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business_rounded),
              activeIcon: Icon(Icons.business_rounded),
              label: 'PROFILE',
            ),
          ],
        ),
      ),
    );
  }
}
