import 'package:flutter/material.dart';
import 'package:ethioworks/models/job_post_model.dart';
import 'package:ethioworks/widgets/profile_avatar.dart';

class JobDetailPanel extends StatelessWidget {
  final JobPost? job;
  final VoidCallback onApply;

  const JobDetailPanel({super.key, this.job, required this.onApply});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (job == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_outline_rounded,
                size: 64, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text('Select a job to view details',
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ProfileAvatar(
                imageUrl: job!.companyProfilePic,
                name: job!.companyName,
                size: 80,
                avatarType: AvatarType.company,
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job!.title,
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      job!.companyName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              _infoTile(theme, Icons.location_on_rounded, 'Location',
                  job!.location ?? 'Remote'),
              const SizedBox(width: 40),
              _infoTile(theme, Icons.payments_rounded, 'Salary', job!.salary),
              const SizedBox(width: 40),
              _infoTile(theme, Icons.timer_rounded, 'Type',
                  job!.locationType.name.toUpperCase()),
            ],
          ),
          const SizedBox(height: 48),
          Text('Description',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(
            job!.description,
            style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.8, color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 40),
          Text('Requirements',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: job!.expectedSkills
                .map((skill) => _skillChip(theme, skill))
                .toList(),
          ),
          const SizedBox(height: 64),
          SizedBox(
            width: double.infinity,
            height: 64,
            child: ElevatedButton(
              onPressed: onApply,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Apply Now',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(ThemeData theme, IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: theme.colorScheme.secondary),
            const SizedBox(width: 8),
            Text(label,
                style: theme.textTheme.labelMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
        const SizedBox(height: 8),
        Text(value,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _skillChip(ThemeData theme, String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: theme.colorScheme.secondary.withValues(alpha: 0.3)),
      ),
      child: Text(
        skill,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
