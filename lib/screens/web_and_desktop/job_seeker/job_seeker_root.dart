import 'package:flutter/material.dart';
import 'package:ethioworks/screens/web_and_desktop/job_seeker/job_seeker_home_page.dart';
import 'package:ethioworks/screens/web_and_desktop/job_seeker/job_seeker_profile_page.dart';
import 'package:ethioworks/screens/web_and_desktop/job_seeker/companies_screen.dart';

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

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.home, label: 'Home'),
    _NavItem(icon: Icons.search, label: 'Browse'),
    _NavItem(icon: Icons.business, label: 'Companies'),
    _NavItem(icon: Icons.person, label: 'Profile'),
  ];

  void _onTap(int idx) => setState(() => _selectedIndex = idx);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 240,
            color: theme.colorScheme.surfaceVariant,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('EthioWorks', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
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
          // Content
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
