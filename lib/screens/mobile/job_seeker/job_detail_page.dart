import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/models/job_post_model.dart';
import 'package:ethioworks/providers/auth_provider.dart';
import 'package:ethioworks/providers/job_provider.dart';
import 'package:ethioworks/providers/application_provider.dart';
import 'package:ethioworks/services/job_seeker_service.dart';
import 'package:ethioworks/screens/mobile/job_seeker/apply_job_page.dart';
import 'package:ethioworks/widgets/profile_avatar.dart';
import 'package:ethioworks/widgets/custom_button.dart';
import 'package:ethioworks/theme.dart';

class JobDetailScreen extends StatefulWidget {
  final String jobId;

  const JobDetailScreen({super.key, required this.jobId});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  JobPost? _job;
  bool _isLoading = true;
  bool _isFollowing = false;
  bool _hasApplied = false;

  @override
  void initState() {
    super.initState();
    _loadJobDetails();
  }

  Future<void> _loadJobDetails() async {
    final jobProvider = context.read<JobProvider>();
    final authProvider = context.read<AuthProvider>();
    final applicationProvider = context.read<ApplicationProvider>();

    final job = await jobProvider.getJobById(widget.jobId);
    final seeker = authProvider.currentJobSeeker;

    bool isFollowing = false;
    if (seeker != null && job != null) {
      isFollowing = seeker.followedCompanies.contains(job.employerId);
    }

    bool hasApplied = false;
    if (authProvider.currentUser != null && job != null) {
      hasApplied = await applicationProvider.hasUserApplied(
        authProvider.currentUser!.id,
        job.id,
      );
    }

    setState(() {
      _job = job;
      _isFollowing = isFollowing;
      _hasApplied = hasApplied;
      _isLoading = false;
    });
  }

  Future<void> _toggleFollow() async {
    final authProvider = context.read<AuthProvider>();
    final seeker = authProvider.currentJobSeeker;

    if (seeker == null || _job == null) return;

    final service = JobSeekerService();
    bool success;

    if (_isFollowing) {
      success = await service.unfollowCompany(seeker.id, _job!.employerId);
    } else {
      success = await service.followCompany(seeker.id, _job!.employerId);
    }

    if (success) {
      final updatedSeeker = await service.getProfile(seeker.id);
      if (updatedSeeker != null) {
        await authProvider.updateUser(updatedSeeker);
      }
      setState(() => _isFollowing = !_isFollowing);
    }
  }

  String _getLocationTypeLabel(LocationType type) {
    switch (type) {
      case LocationType.remote:
        return '🌍 Remote';
      case LocationType.permanent:
        return '🏢 Permanent';
      case LocationType.onSite:
        return '📍 ${_job?.location ?? "On-Site"}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_job == null) {
      return Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(),
        body: const Center(child: Text('Job not found')),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Job Details',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          _buildActionButton(
            theme,
            icon: _isFollowing
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            onTap: _toggleFollow,
            iconColor: _isFollowing
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
          ),
          const SizedBox(width: AppSpacing.md),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: AppSpacing.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileAvatar(
                        imageUrl: _job!.companyProfilePic,
                        name: _job!.companyName,
                        size: 72,
                        avatarType: AvatarType.company,
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _job!.title,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              _job!.companyName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  _buildDetailedInfoRow(theme),
                  const SizedBox(height: AppSpacing.xxl),
                  _buildSectionHeader(theme, 'Description'),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    _job!.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  if (_job!.roles.isNotEmpty) ...[
                    _buildSectionHeader(theme, 'Roles & Responsibilities'),
                    const SizedBox(height: AppSpacing.md),
                    ..._job!.roles
                        .map((role) => _buildBulletPoint(theme, role)),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                  if (_job!.expectedSkills.isNotEmpty) ...[
                    _buildSectionHeader(theme, 'Required Skills'),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: _job!.expectedSkills
                          .map((skill) => _buildSkillChip(theme, skill))
                          .toList(),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                  _buildSectionHeader(theme, 'Education'),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    _job!.education,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
          _buildBottomBar(theme),
        ],
      ),
    );
  }

  Widget _buildActionButton(ThemeData theme,
      {required IconData icon, required VoidCallback onTap, Color? iconColor}) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
        border: Border.all(color: theme.colorScheme.outline, width: 1),
      ),
      child: IconButton(
        icon: Icon(icon,
            color: iconColor ?? theme.colorScheme.onSurface, size: 20),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildDetailedInfoRow(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            theme,
            Icons.location_on_rounded,
            _getLocationTypeLabel(_job!.locationType),
            'Location',
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildInfoCard(
            theme,
            Icons.payments_rounded,
            _job!.salary,
            'Salary',
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
      ThemeData theme, IconData icon, String value, String label) {
    return Container(
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: theme.colorScheme.outline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4.0),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w900,
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _buildBulletPoint(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(ThemeData theme, String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: theme.colorScheme.outline, width: 1),
      ),
      child: Text(
        skill,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBottomBar(ThemeData theme) {
    return Container(
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.colorScheme.outline)),
      ),
      child: SafeArea(
        child: _hasApplied
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border:
                      Border.all(color: theme.colorScheme.outline, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_rounded,
                        color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Successfully Applied',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              )
            : CustomButton(
                text: 'Apply for this Job',
                icon: Icons.send_rounded,
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ApplyJobScreen(job: _job!)),
                  );
                  if (result == true) {
                    setState(() => _hasApplied = true);
                  }
                },
              ),
      ),
    );
  }
}
