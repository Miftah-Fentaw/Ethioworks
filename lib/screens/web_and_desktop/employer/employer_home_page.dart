import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/providers/auth_provider.dart';
import 'package:ethioworks/providers/job_provider.dart';
import 'package:ethioworks/screens/web_and_desktop/employer/post_job_page.dart';
import 'package:ethioworks/screens/web_and_desktop/employer/employer_job_detail_page.dart';
import 'package:ethioworks/screens/web_and_desktop/employer/employer_profile_page.dart';
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
        titleSpacing: AppSpacing.lg,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(Icons.work_rounded,
                  color: theme.colorScheme.primary, size: 24),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              'EthioWorks',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon:
                Icon(Icons.search_rounded, color: theme.colorScheme.onSurface),
            onPressed: () {},
            tooltip: 'Search Posts',
          ),
          const SizedBox(width: AppSpacing.sm),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const EmployerProfileScreen()),
              );
            },
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ProfileAvatar(
                imageUrl: employer?.profilePic,
                name: employer?.companyOrPersonalName ?? 'Company',
                size: 36,
                avatarType: AvatarType.employer,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: RefreshIndicator(
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
                        padding: AppSpacing.paddingLg,
                        itemCount: jobs.length,
                        itemBuilder: (context, index) {
                          final job = jobs[index];
                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppSpacing.md),
                            child: JobCard(
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
                            ),
                          );
                        },
                      ),
          ),
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
        label: Text(
          'Post Job',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.post_add_rounded,
                size: 64,
                color: theme.colorScheme.primary.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'No job postings yet',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Tap "Post Job" to create your first opening.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
