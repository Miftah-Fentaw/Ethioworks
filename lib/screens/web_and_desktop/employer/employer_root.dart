import 'package:flutter/material.dart';
import 'package:ethioworks/screens/web_and_desktop/employer/employer_home_page.dart';
import 'package:ethioworks/screens/web_and_desktop/employer/post_job_page.dart';
import 'package:ethioworks/screens/web_and_desktop/employer/all_applicants_screen.dart';
import 'package:ethioworks/screens/web_and_desktop/employer/employer_profile_page.dart';

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

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.home, label: 'Home'),
    _NavItem(icon: Icons.post_add, label: 'Post Job'),
    _NavItem(icon: Icons.people, label: 'Applicants'),
    _NavItem(icon: Icons.person, label: 'Profile'),
  ];

  void _onTap(int idx) => setState(() => _selectedIndex = idx);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 240,
            color: theme.colorScheme.surfaceVariant,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Employer', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _navItems.length,
                      itemBuilder: (context, i) {
                        final item = _navItems[i];
                        final selected = i == _selectedIndex;
                        return Material(
                          color: selected ? theme.colorScheme.primary.withOpacity(0.12) : Colors.transparent,
                          child: ListTile(
                            leading: Icon(item.icon, color: selected ? theme.colorScheme.primary : null),
                            title: Text(item.label, style: selected ? TextStyle(color: theme.colorScheme.primary) : null),
                            selected: selected,
                            onTap: () => _onTap(i),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
