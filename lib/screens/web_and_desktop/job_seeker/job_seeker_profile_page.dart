import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/providers/auth_provider.dart';
import 'package:ethioworks/widgets/profile_avatar.dart';
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
      backgroundColor: theme.colorScheme.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth >
              800; // Threshold for web/desktop-like layout

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
                            ProfileAvatar(
                                imageUrl: seeker.profilePic,
                                name: seeker.name,
                                size: 200,
                                avatarType: AvatarType.jobSeeker),
                            const SizedBox(height: AppSpacing.lg),
                            Text(seeker.name,
                                style: theme.textTheme.headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                            if (seeker.title != null) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Text(seeker.title!,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                      color:
                                          theme.colorScheme.onSurfaceVariant)),
                            ],
                            const SizedBox(height: AppSpacing.xl),
                            OutlinedButton.icon(
                              onPressed: () async {
                                await authProvider.logout();
                                if (!context.mounted) return;
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/',
                                  (route) => false,
                                );
                              },
                              icon: const Icon(Icons.logout, size: 20),
                              label: const Text('Logout'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: theme.colorScheme.error,
                                side:
                                    BorderSide(color: theme.colorScheme.error),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xl),
                      // Right side: Details
                      Flexible(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: theme.colorScheme.outline
                                    .withValues(alpha: 0.1)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (seeker.about != null) ...[
                                Text('About',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: AppSpacing.md),
                                Text(seeker.about!,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                        height: 1.6,
                                        color: theme
                                            .colorScheme.onSurfaceVariant)),
                                const SizedBox(height: AppSpacing.xl),
                                Divider(
                                    color: theme.colorScheme.outline
                                        .withValues(alpha: 0.1)),
                                const SizedBox(height: AppSpacing.xl),
                              ],
                              _buildInfoRow(Icons.email_outlined, 'Email',
                                  seeker.email, theme),
                              if (seeker.phoneNo != null)
                                _buildInfoRow(Icons.phone_outlined, 'Phone',
                                    seeker.phoneNo!, theme),
                              const SizedBox(height: AppSpacing.lg),
                              _buildInfoRow(
                                  Icons.business_rounded,
                                  'Following',
                                  '${seeker.followedCompanies.length} companies',
                                  theme),
                            ],
                          ),
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
                        ProfileAvatar(
                            imageUrl: seeker.profilePic,
                            name: seeker.name,
                            size: 100,
                            avatarType: AvatarType.jobSeeker),
                        const SizedBox(height: AppSpacing.md),
                        Text(seeker.name,
                            style: theme.textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        if (seeker.title != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(seeker.title!,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant)),
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
                          Text('About',
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: AppSpacing.sm),
                          Text(seeker.about!,
                              style: theme.textTheme.bodyMedium),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                        _buildInfoRow(
                            Icons.email_outlined, 'Email', seeker.email, theme),
                        if (seeker.phoneNo != null)
                          _buildInfoRow(Icons.phone_outlined, 'Phone',
                              seeker.phoneNo!, theme),
                        const SizedBox(height: AppSpacing.sm),
                        _buildInfoRow(
                            Icons.business_rounded,
                            'Following',
                            '${seeker.followedCompanies.length} companies',
                            theme),
                        const SizedBox(height: AppSpacing.xl),
                        OutlinedButton.icon(
                          onPressed: () async {
                            await authProvider.logout();
                            if (!context.mounted) return;
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/',
                              (route) => false,
                            );
                          },
                          icon: const Icon(Icons.logout, size: 20),
                          label: const Text('Logout'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.colorScheme.error,
                            side: BorderSide(color: theme.colorScheme.error),
                            minimumSize: const Size(double.infinity, 50),
                          ),
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

  Widget _buildInfoRow(
      IconData icon, String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 2),
              Text(value,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}
