import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/providers/auth_provider.dart';
import 'package:ethioworks/screens/web_and_desktop/auth/signin.dart';
import 'package:ethioworks/widgets/profile_avatar.dart';
import 'package:ethioworks/widgets/custom_button.dart';
import 'package:ethioworks/theme.dart';

class SeekerProfileScreen extends StatelessWidget {
  const SeekerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = context.watch<AuthProvider>();
    final seeker = authProvider.currentJobSeeker;

    if (seeker == null) {
      return const Scaffold(body: Center(child: Text('User not found')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth > 800; // Threshold for web/desktop-like layout

          if (isWide) {
            // Web/Desktop layout: Row with avatar/header on left, details on right
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: AppSpacing.paddingXl,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side: Avatar and basic info
                      Flexible(
                        flex: 1,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ProfileAvatar(imageUrl: seeker.profilePic, name: seeker.name, size: 200, avatarType: AvatarType.jobSeeker),
                            const SizedBox(height: AppSpacing.lg),
                            Text(seeker.name, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                            if (seeker.title != null) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Text(seeker.title!, style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                            ],
                            const SizedBox(height: AppSpacing.xl),
                            CustomButton(
                              text: 'Logout',
                              icon: Icons.logout,
                              onPressed: () async {
                                await authProvider.logout();
                                if (!context.mounted) return;
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (_) => const WebLoginScreen()),
                                  (route) => false,
                                );
                              },
                              backgroundColor: theme.colorScheme.error,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xl),
                      // Right side: Details
                      Flexible(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (seeker.about != null) ...[
                              Text('About', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: AppSpacing.md),
                              Text(seeker.about!, style: theme.textTheme.bodyLarge),
                              const SizedBox(height: AppSpacing.xl),
                            ],
                            _buildInfoRow(Icons.email, 'Email', seeker.email, theme),
                            if (seeker.phoneNo != null) _buildInfoRow(Icons.phone, 'Phone', seeker.phoneNo!, theme),
                            const SizedBox(height: AppSpacing.lg),
                            _buildInfoRow(Icons.business, 'Following', '${seeker.followedCompanies.length} companies', theme),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            // Original mobile layout (unchanged)
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: AppSpacing.paddingXl,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                    ),
                    child: Column(
                      children: [
                        ProfileAvatar(imageUrl: seeker.profilePic, name: seeker.name, size: 100, avatarType: AvatarType.jobSeeker),
                        const SizedBox(height: AppSpacing.md),
                        Text(seeker.name, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        if (seeker.title != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(seeker.title!, style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                        ],
                      ],
                    ),
                  ),
                  Padding(
                    padding: AppSpacing.paddingLg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (seeker.about != null) ...[
                          Text('About', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: AppSpacing.sm),
                          Text(seeker.about!, style: theme.textTheme.bodyMedium),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                        _buildInfoRow(Icons.email, 'Email', seeker.email, theme),
                        if (seeker.phoneNo != null) _buildInfoRow(Icons.phone, 'Phone', seeker.phoneNo!, theme),
                        const SizedBox(height: AppSpacing.sm),
                        _buildInfoRow(Icons.business, 'Following', '${seeker.followedCompanies.length} companies', theme),
                        const SizedBox(height: AppSpacing.xl),
                        CustomButton(
                          text: 'Logout',
                          icon: Icons.logout,
                          onPressed: () async {
                            await authProvider.logout();
                            if (!context.mounted) return;
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => const WebLoginScreen()),
                              (route) => false,
                            );
                          },
                          backgroundColor: theme.colorScheme.error,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}