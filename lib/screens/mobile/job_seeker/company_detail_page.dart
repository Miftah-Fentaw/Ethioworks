import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/models/employer_model.dart';
import 'package:ethioworks/models/job_post_model.dart';
import 'package:ethioworks/providers/job_provider.dart';
import 'package:ethioworks/providers/auth_provider.dart';
import 'package:ethioworks/services/job_seeker_service.dart';
import 'package:ethioworks/widgets/profile_avatar.dart';
import 'package:ethioworks/widgets/custom_button.dart';
import 'package:ethioworks/theme.dart';
import 'package:ethioworks/screens/mobile/job_seeker/job_detail_page.dart';

class CompanyDetailScreen extends StatefulWidget {
  final Employer employer;

  const CompanyDetailScreen({super.key, required this.employer});

  @override
  State<CompanyDetailScreen> createState() => _CompanyDetailScreenState();
}

class _CompanyDetailScreenState extends State<CompanyDetailScreen> {
  bool _loading = true;
  List<JobPost> _companyJobs = [];
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final jobProvider = context.read<JobProvider>();
    final authProvider = context.read<AuthProvider>();
    final seeker = authProvider.currentJobSeeker;

    await jobProvider.loadEmployerJobs(widget.employer.id);

    if (mounted) {
      setState(() {
        _companyJobs = jobProvider.jobs;
        _loading = false;
        if (seeker != null) {
          _isFollowing = seeker.followedCompanies.contains(widget.employer.id);
        }
      });
    }
  }

  Future<void> _toggleFollow() async {
    final authProvider = context.read<AuthProvider>();
    final seeker = authProvider.currentJobSeeker;

    if (seeker == null) return;

    final service = JobSeekerService();
    bool success;

    if (_isFollowing) {
      success = await service.unfollowCompany(seeker.id, widget.employer.id);
    } else {
      success = await service.followCompany(seeker.id, widget.employer.id);
    }

    if (success) {
      final updatedSeeker = await service.getProfile(seeker.id);
      if (updatedSeeker != null) {
        await authProvider.updateUser(updatedSeeker);
      }
      setState(() => _isFollowing = !_isFollowing);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Company Profile',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCompanyHeader(theme),
            const SizedBox(height: AppSpacing.xxl),
            if (widget.employer.description != null &&
                widget.employer.description!.isNotEmpty) ...[
              _buildSectionHeader(theme, 'About'),
              const SizedBox(height: AppSpacing.md),
              Text(
                widget.employer.description!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
            _buildSectionHeader(theme, 'Active Jobs'),
            const SizedBox(height: AppSpacing.md),
            _buildJobsList(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyHeader(ThemeData theme) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.lg),
        ProfileAvatar(
          imageUrl: widget.employer.profilePic,
          name: widget.employer.companyOrPersonalName,
          size: 112,
          avatarType: AvatarType.company,
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          widget.employer.companyOrPersonalName,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_alt_rounded,
                size: 16, color: theme.colorScheme.primary),
            const SizedBox(width: AppSpacing.sm),
            Text(
              '${widget.employer.followers} Followers',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        SizedBox(
          width: 200,
          child: CustomButton(
            text: _isFollowing ? 'Following' : 'Follow',
            icon: _isFollowing ? Icons.check_rounded : Icons.add_rounded,
            onPressed: _toggleFollow,
            isOutlined: _isFollowing,
          ),
        ),
      ],
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

  Widget _buildJobsList(ThemeData theme) {
    if (_loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_companyJobs.isEmpty) {
      return Container(
        width: double.infinity,
        padding: AppSpacing.paddingXl,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: theme.colorScheme.outline, width: 1),
        ),
        child: Column(
          children: [
            Icon(Icons.work_off_rounded,
                size: 48,
                color:
                    theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No active jobs at the moment',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _companyJobs.length,
      itemBuilder: (context, index) {
        final job = _companyJobs[index];
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: theme.colorScheme.outline, width: 1),
          ),
          child: ListTile(
            contentPadding: AppSpacing.paddingLg,
            title: Text(
              job.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Row(
                children: [
                  Icon(Icons.location_on_rounded,
                      size: 14, color: theme.colorScheme.primary),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '${job.location} • ${job.locationType.name}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            trailing: Icon(Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurfaceVariant),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => JobDetailScreen(jobId: job.id),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
