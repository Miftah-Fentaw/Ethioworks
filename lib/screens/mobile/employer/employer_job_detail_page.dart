import 'package:ethioworks/screens/mobile/employer/applicant_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/models/job_post_model.dart';
import 'package:ethioworks/providers/job_provider.dart';
import 'package:ethioworks/providers/application_provider.dart';
import 'package:ethioworks/screens/mobile/employer/post_job_page.dart';
import 'package:ethioworks/widgets/profile_avatar.dart';
import 'package:ethioworks/widgets/custom_button.dart';
import 'package:ethioworks/theme.dart';

class EmployerJobDetailScreen extends StatefulWidget {
  final String jobId;

  const EmployerJobDetailScreen({super.key, required this.jobId});

  @override
  State<EmployerJobDetailScreen> createState() =>
      _EmployerJobDetailScreenState();
}

class _EmployerJobDetailScreenState extends State<EmployerJobDetailScreen> {
  JobPost? _job;
  int _applicantsCount = 0;

  @override
  void initState() {
    super.initState();
    _loadJobDetails();
  }

  Future<void> _loadJobDetails() async {
    final jobProvider = context.read<JobProvider>();
    final applicationProvider = context.read<ApplicationProvider>();

    final job = await jobProvider.getJobById(widget.jobId);
    if (job != null) {
      await applicationProvider.loadApplicationsByJob(job.id);
      setState(() {
        _job = job;
        _applicantsCount = applicationProvider.applications.length;
      });
    }
  }

  Future<void> _deleteJob() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Job'),
        content:
            const Text('Are you sure you want to delete this job posting?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete',
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await context.read<JobProvider>().deleteJob(widget.jobId);
      if (success && mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_job == null) {
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
        ),
        body: const Center(child: CircularProgressIndicator()),
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
          IconButton(
            icon: Icon(Icons.edit_rounded, color: theme.colorScheme.onSurface),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => PostJobScreen(jobToEdit: _job)),
              );
              if (result == true) _loadJobDetails();
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_rounded, color: theme.colorScheme.error),
            onPressed: _deleteJob,
          ),
          const SizedBox(width: AppSpacing.sm),
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
                  _buildHeader(theme),
                  const SizedBox(height: AppSpacing.xxl),
                  _buildStatsSection(theme),
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
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
          _buildBottomBar(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
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
                ),
              ),
              const SizedBox(height: 4.0),
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
    );
  }

  Widget _buildStatsSection(ThemeData theme) {
    return Container(
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: theme.colorScheme.outline, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
              theme, 'Likes', _job!.likes.toString(), Icons.thumb_up_rounded),
          _buildStatItem(theme, 'Dislikes', _job!.dislikes.toString(),
              Icons.thumb_down_rounded),
          _buildStatItem(theme, 'Applicants', _applicantsCount.toString(),
              Icons.people_rounded),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      ThemeData theme, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
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

  Widget _buildBottomBar(ThemeData theme) {
    return Container(
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border:
            Border(top: BorderSide(color: theme.colorScheme.outline, width: 1)),
      ),
      child: SafeArea(
        child: CustomButton(
          text: 'View Applicants ($_applicantsCount)',
          icon: Icons.people_rounded,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ApplicantsScreen(job: _job!)),
            );
          },
        ),
      ),
    );
  }
}
