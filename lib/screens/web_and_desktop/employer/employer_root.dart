import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/providers/auth_provider.dart';
import 'package:ethioworks/providers/theme_provider.dart';
import 'package:ethioworks/widgets/profile_avatar.dart';
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

  final List<String> _navLabels = [
    'My Jobs',
    'Post Job',
    'Applicants',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = context.watch<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final employer = authProvider.currentEmployer;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          // Top Navigation Bar (matching job seeker style)
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 48),
            decoration: BoxDecoration(
              color: const Color(0xFF11213A),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Logo
                Row(
                  children: [
                    Icon(
                      Icons.business_rounded,
                      color: const Color(0xFF40E0D0),
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'EthioWorks',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 64),
                // Nav Links
                Row(
                  children: List.generate(_navLabels.length, (index) {
                    return _topNavLink(
                        _navLabels[index], _selectedIndex == index, index);
                  }),
                ),
                const Spacer(),
                // Right side actions
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        themeProvider.isDarkMode
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        color: Colors.white70,
                      ),
                      onPressed: () => themeProvider.toggleTheme(),
                      tooltip: 'Toggle Theme',
                    ),
                    const SizedBox(width: 16),
                    ProfileAvatar(
                      imageUrl: employer?.profilePic,
                      name: employer?.companyOrPersonalName ?? 'Company',
                      size: 40,
                      avatarType: AvatarType.company,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employer?.companyOrPersonalName ?? 'Company',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Employer',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.keyboard_arrow_down_rounded,
                          color: Colors.white70, size: 20),
                      offset: const Offset(0, 40),
                      onSelected: (value) async {
                        if (value == 'logout') {
                          await authProvider.logout();
                        } else if (value == 'profile') {
                          setState(() => _selectedIndex = 3);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'profile',
                          child: Row(
                            children: [
                              Icon(Icons.person_outline),
                              SizedBox(width: 12),
                              Text('Profile'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'logout',
                          child: Row(
                            children: [
                              Icon(Icons.logout, color: Colors.red),
                              SizedBox(width: 12),
                              Text('Logout',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Main Content Area
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }

  Widget _topNavLink(String label, bool isActive, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        borderRadius: BorderRadius.circular(8),
        hoverColor: Colors.white.withValues(alpha: 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.7),
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                fontSize: 15,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isActive ? 6 : 0,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF40E0D0),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
