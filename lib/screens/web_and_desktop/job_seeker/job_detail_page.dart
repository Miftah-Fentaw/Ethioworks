import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/models/job_post_model.dart';
import 'package:ethioworks/providers/auth_provider.dart';
import 'package:ethioworks/providers/job_provider.dart';
import 'package:ethioworks/providers/application_provider.dart';
import 'package:ethioworks/services/job_seeker_service.dart';
import 'package:ethioworks/screens/web_and_desktop/job_seeker/apply_job_page.dart';
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
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_job == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Job not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
        actions: [
          IconButton(
            icon: Icon(
              _isFollowing ? Icons.favorite : Icons.favorite_border,
              color: _isFollowing
                  ? theme.colorScheme.tertiary
                  : theme.colorScheme.onSurface,
            ),
            onPressed: _toggleFollow,
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: AppSpacing.paddingLg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ProfileAvatar(
                              imageUrl: _job!.companyProfilePic,
                              name: _job!.companyName,
                              size: 70,
                              avatarType: AvatarType.company,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _job!.title,
                                    style:
                                        theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    _job!.companyName,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 18, color: theme.colorScheme.primary),
                            const SizedBox(width: AppSpacing.xs),
                            Text(_getLocationTypeLabel(_job!.locationType),
                                style: theme.textTheme.bodyMedium),
                            const SizedBox(width: AppSpacing.lg),
                            Icon(Icons.payments_outlined,
                                size: 18, color: theme.colorScheme.secondary),
                            const SizedBox(width: AppSpacing.xs),
                            Flexible(
                                child: Text(_job!.salary,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600))),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        _buildSection('Description', _job!.description, theme),
                        const SizedBox(height: AppSpacing.lg),
                        if (_job!.roles.isNotEmpty) ...[
                          _buildListSection(
                              'Roles & Responsibilities', _job!.roles, theme),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                        if (_job!.expectedSkills.isNotEmpty) ...[
                          _buildChipSection(
                              'Required Skills', _job!.expectedSkills, theme),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                        _buildSection('Education', _job!.education, theme),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 800),
                padding: AppSpacing.paddingLg,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                      top: BorderSide(
                          color: theme.colorScheme.outline
                              .withValues(alpha: 0.2))),
                ),
                child: SafeArea(
                  child: _hasApplied
                      ? Container(
                          padding: AppSpacing.paddingMd,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle,
                                  color: theme.colorScheme.primary),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Already Applied',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      : CustomButton(
                          text: 'Apply Now',
                          icon: Icons.send,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.sm),
        Text(content, style: theme.textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildListSection(String title, List<String> items, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.sm),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: theme.textTheme.bodyMedium),
                  Expanded(
                      child: Text(item, style: theme.textTheme.bodyMedium)),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildChipSection(String title, List<String> items, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: items
              .map((skill) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(skill,
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w600)),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
