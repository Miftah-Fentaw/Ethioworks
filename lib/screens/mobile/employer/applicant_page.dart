import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/models/job_post_model.dart';
import 'package:ethioworks/providers/application_provider.dart';
import 'package:ethioworks/screens/mobile/employer/applicant_detail_page.dart';
import 'package:ethioworks/widgets/profile_avatar.dart';
import 'package:ethioworks/theme.dart';

class ApplicantsScreen extends StatefulWidget {
  final JobPost job;

  const ApplicantsScreen({super.key, required this.job});

  @override
  State<ApplicantsScreen> createState() => _ApplicantsScreenState();
}

class _ApplicantsScreenState extends State<ApplicantsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ApplicationProvider>().loadApplicationsByJob(widget.job.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final applicationProvider = context.watch<ApplicationProvider>();
    final applications = applicationProvider.applications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Applicants'),
      ),
      body: applicationProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : applications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 80, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'No applications yet',
                        style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: AppSpacing.paddingMd,
                  itemCount: applications.length,
                  itemBuilder: (context, index) {
                    final application = applications[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ApplicantDetailScreen(application: application),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: Padding(
                          padding: AppSpacing.paddingMd,
                          child: Row(
                            children: [
                              ProfileAvatar(imageUrl: null, name: application.applicantName, size: 50, avatarType: AvatarType.jobSeeker),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      application.applicantName,
                                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    if (application.applicantTitle != null) ...[
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(
                                        application.applicantTitle!,
                                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                      ),
                                    ],
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      application.email,
                                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
