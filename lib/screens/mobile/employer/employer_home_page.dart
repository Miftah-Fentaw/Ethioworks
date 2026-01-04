import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/providers/auth_provider.dart';
import 'package:ethioworks/providers/job_provider.dart';
import 'package:ethioworks/screens/mobile/employer/post_job_page.dart';
import 'package:ethioworks/screens/mobile/employer/employer_job_detail_page.dart';
import 'package:ethioworks/screens/mobile/employer/employer_profile_page.dart';
import 'package:ethioworks/widgets/job_card.dart';
import 'package:ethioworks/widgets/profile_avatar.dart';
import 'package:ethioworks/theme.dart';

class EmployerHomeScreen extends StatefulWidget {
  const EmployerHomeScreen({super.key});

  @override
  State<EmployerHomeScreen> createState() => _EmployerHomeScreenState();
}

class _EmployerHomeScreenState extends State<EmployerHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final employer = context.read<AuthProvider>().currentEmployer;
      if (employer != null) {
        context.read<JobProvider>().loadEmployerJobs(employer.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = context.watch<AuthProvider>();
    final jobProvider = context.watch<JobProvider>();
    final employer = authProvider.currentEmployer;

    final jobs = jobProvider.jobs;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EthioWorks',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onSurface,
                letterSpacing: -1,
              ),
            ),
            Text(
              'Manage your job postings',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const EmployerProfileScreen()),
              );
            },
            child: ProfileAvatar(
              imageUrl: employer?.profilePic,
              name: employer?.companyOrPersonalName ?? 'Company',
              size: 40,
              avatarType: AvatarType.employer,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
        ],
      ),
      body: RefreshIndicator(
        color: theme.colorScheme.primary,
        backgroundColor: theme.colorScheme.surface,
        onRefresh: () async {
          if (employer != null) {
            await context.read<JobProvider>().loadEmployerJobs(employer.id);
          }
        },
        child: jobProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : jobs.isEmpty
                ? _buildEmptyState(theme)
                : ListView.builder(
                    padding: AppSpacing.paddingMd,
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      return JobCard(
                        job: job,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EmployerJobDetailScreen(jobId: job.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PostJobScreen()),
          );
          if (employer != null && mounted) {
            context.read<JobProvider>().loadEmployerJobs(employer.id);
          }
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Post Job'),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg)),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingXl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: AppSpacing.paddingXl,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.post_add_rounded,
                size: 64,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'No jobs posted yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'You haven\'t posted any jobs. Start growing your team by posting your first opportunity.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
