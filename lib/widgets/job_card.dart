import 'package:flutter/material.dart';
import 'package:ethioworks/models/job_post_model.dart';
import 'package:ethioworks/widgets/profile_avatar.dart';
import 'package:ethioworks/theme.dart';

class JobCard extends StatelessWidget {
  final JobPost job;
  final VoidCallback onTap;
  final VoidCallback? onLike;
  final VoidCallback? onDislike;
  final String? userReaction;

  const JobCard({
    super.key,
    required this.job,
    required this.onTap,
    this.onLike,
    this.onDislike,
    this.userReaction,
  });

  String _getLocationTypeLabel(LocationType type) {
    switch (type) {
      case LocationType.remote:
        return '🌍 Remote';
      case LocationType.permanent:
        return '🏢 Permanent';
      case LocationType.onSite:
        return '📍 ${job.location ?? "On-Site"}';
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: theme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileAvatar(
                    imageUrl: job.companyProfilePic,
                    name: job.companyName,
                    size: 56,
                    avatarType: AvatarType.company,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                            fontSize: 18,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          job.companyName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    _getTimeAgo(job.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildInfoRow(theme),
              const SizedBox(height: AppSpacing.md),
              Text(
                job.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (job.expectedSkills.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                _buildSkillsWrap(theme),
              ],
              if (onLike != null && onDislike != null) ...[
                const SizedBox(height: AppSpacing.lg),
                Divider(
                  color: theme.colorScheme.outline,
                  height: 1,
                ),
                const SizedBox(height: AppSpacing.md),
                _buildReactionRow(theme),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(ThemeData theme) {
    return Row(
      children: [
        _buildIconBadge(
          theme,
          Icons.location_on_rounded,
          _getLocationTypeLabel(job.locationType),
        ),
        const SizedBox(width: AppSpacing.md),
        _buildIconBadge(
          theme,
          Icons.payments_rounded,
          job.salary,
        ),
      ],
    );
  }

  Widget _buildIconBadge(ThemeData theme, IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: AppSpacing.xs),
        Flexible(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsWrap(ThemeData theme) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: job.expectedSkills.take(3).map((skill) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Text(
            skill,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w700,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReactionRow(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildReactionButton(
          theme,
          isSelected: userReaction == 'like',
          icon: Icons.thumb_up_rounded,
          selectedIcon: Icons.thumb_up_rounded,
          count: job.likes,
          onTap: onLike!,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: AppSpacing.md),
        _buildReactionButton(
          theme,
          isSelected: userReaction == 'dislike',
          icon: Icons.thumb_down_rounded,
          selectedIcon: Icons.thumb_down_rounded,
          count: job.dislikes,
          onTap: onDislike!,
          color: theme.colorScheme.error,
        ),
      ],
    );
  }

  Widget _buildReactionButton(
    ThemeData theme, {
    required bool isSelected,
    required IconData icon,
    required IconData selectedIcon,
    required int count,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              size: 20,
              color: isSelected ? color : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '$count',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isSelected ? color : theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
