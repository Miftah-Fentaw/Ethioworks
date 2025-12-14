import 'package:ethioworks/screens/mobile/auth/signin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/providers/auth_provider.dart';
import 'package:ethioworks/widgets/profile_avatar.dart';
import 'package:ethioworks/widgets/custom_button.dart';
import 'package:ethioworks/theme.dart';

class EmployerProfileScreen extends StatelessWidget {
  const EmployerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = context.watch<AuthProvider>();
    final employer = authProvider.currentEmployer;

    if (employer == null) {
      return const Scaffold(body: Center(child: Text('User not found')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Company Profile')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: AppSpacing.paddingXl,
              decoration: BoxDecoration(color: theme.colorScheme.primaryContainer),
              child: Column(
                children: [
                  ProfileAvatar(imageUrl: employer.profilePic, name: employer.companyOrPersonalName, size: 100, avatarType: AvatarType.employer),
                  const SizedBox(height: AppSpacing.md),
                  Text(employer.companyOrPersonalName, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppSpacing.sm),
                  Text('${employer.followers} followers', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            Padding(
              padding: AppSpacing.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (employer.description != null) ...[
                    Text('About', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: AppSpacing.sm),
                    Text(employer.description!, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  Row(
                    children: [
                      Icon(Icons.email, size: 20, color: theme.colorScheme.primary),
                      const SizedBox(width: AppSpacing.md),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                          Text(employer.email, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
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
}
