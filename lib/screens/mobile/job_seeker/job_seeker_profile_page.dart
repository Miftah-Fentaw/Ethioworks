import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/providers/auth_provider.dart';
import 'package:ethioworks/screens/mobile/auth/signin.dart';
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
      body: SingleChildScrollView(
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
                  ProfileAvatar(imageUrl: seeker.profilePic, name: seeker.name, size: 100),
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
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
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
