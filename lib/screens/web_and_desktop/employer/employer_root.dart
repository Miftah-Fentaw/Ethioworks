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
          // Modern Sidebar Navigation
          Container(
            width: 260,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Logo/Title
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.business_rounded,
                          color: theme.colorScheme.primary,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Employer',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                      height: 1,
                      color: theme.colorScheme.outline.withValues(alpha: 0.2)),
                  const SizedBox(height: 16),
                  // Navigation Items
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: _navItems.length,
                      itemBuilder: (context, i) {
                        final item = _navItems[i];
                        final selected = i == _selectedIndex;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _onTap(i),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selected
                                      ? theme.colorScheme.primary
                                          .withValues(alpha: 0.12)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: selected
                                      ? Border.all(
                                          color: theme.colorScheme.primary
                                              .withValues(alpha: 0.3),
                                          width: 1,
                                        )
                                      : null,
                                ),
                                child: ListTile(
                                  leading: Icon(
                                    item.icon,
                                    color: selected
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurfaceVariant,
                                    size: 24,
                                  ),
                                  title: Text(
                                    item.label,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: selected
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.onSurface,
                                      fontWeight: selected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 4),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Main Content Area
          Expanded(
            child: Container(
              color: theme.colorScheme.background,
              child: _pages[_selectedIndex],
            ),
          ),
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
