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
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.work_rounded,
                color: theme.colorScheme.primary, size: 28),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'EthioWorks',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: ProfileAvatar(
              imageUrl: employer?.profilePic,
              name: employer?.companyOrPersonalName ?? 'Company',
              size: 32,
              avatarType: AvatarType.employer,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const EmployerProfileScreen()),
              );
            },
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: RefreshIndicator(
            onRefresh: () async {
              if (employer != null) {
                await context.read<JobProvider>().loadEmployerJobs(employer.id);
              }
            },
            child: jobProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : jobs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.post_add,
                                size: 80,
                                color: theme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.5)),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              'No job postings yet',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Tap + to create your first job post',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      )
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
        icon: const Icon(Icons.add),
        label: const Text('Post Job'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
    );
  }
}
