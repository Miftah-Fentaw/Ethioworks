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

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: AppSpacing.paddingMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ProfileAvatar(
                    imageUrl: job.companyProfilePic,
                    name: job.companyName,
                    size: 50,
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
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          job.companyName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _getTimeAgo(job.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    _getLocationTypeLabel(job.locationType),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Icon(Icons.payments_outlined, size: 16, color: theme.colorScheme.secondary),
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Text(
                      job.salary,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                job.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (job.expectedSkills.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: job.expectedSkills.take(3).map((skill) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      skill,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )).toList(),
                ),
              ],
              if (onLike != null && onDislike != null) ...[
                const SizedBox(height: AppSpacing.md),
                Divider(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: onLike,
                        child: Padding(
                          padding: AppSpacing.paddingSm,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                userReaction == 'like' ? Icons.thumb_up : Icons.thumb_up_outlined,
                                size: 18,
                                color: userReaction == 'like' ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                '${job.likes}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: userReaction == 'like' ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: onDislike,
                        child: Padding(
                          padding: AppSpacing.paddingSm,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                userReaction == 'dislike' ? Icons.thumb_down : Icons.thumb_down_outlined,
                                size: 18,
                                color: userReaction == 'dislike' ? theme.colorScheme.tertiary : theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                '${job.dislikes}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: userReaction == 'dislike' ? theme.colorScheme.tertiary : theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
