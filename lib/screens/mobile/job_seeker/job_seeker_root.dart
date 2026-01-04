import 'package:ethioworks/screens/mobile/job_seeker/job_seeker_home_page.dart';
import 'package:ethioworks/screens/mobile/job_seeker/job_seeker_profile_page.dart';
import 'package:ethioworks/screens/mobile/job_seeker/companies_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JobSeekerRoot extends StatefulWidget {
  const JobSeekerRoot({super.key});

  @override
  State<JobSeekerRoot> createState() => _JobSeekerRootState();
}

class _JobSeekerRootState extends State<JobSeekerRoot> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    SeekerHomeScreen(),
    CompaniesScreen(),
    SeekerProfileScreen(),
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
          items:  [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.globe),
              activeIcon: Icon(CupertinoIcons.globe),
              label: 'browse',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.building_2_fill),
              activeIcon: Icon(CupertinoIcons.building_2_fill),
              label: 'COMPANIES',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              activeIcon: Icon(CupertinoIcons.person),
              label: 'PROFILE',
            ),
          ],
        ),
      ),
    );
  }
}
