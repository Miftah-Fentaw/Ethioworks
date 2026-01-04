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
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Applicants',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon:
                Icon(Icons.search_rounded, color: theme.colorScheme.onSurface),
            onPressed: () {},
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: applicationProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : applications.isEmpty
              ? _buildEmptyState(theme)
              : ListView.builder(
                  padding: AppSpacing.paddingLg,
                  itemCount: applications.length,
                  itemBuilder: (context, index) {
                    final application = applications[index];
                    return _buildApplicantCard(context, theme, application);
                  },
                ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.inbox_rounded,
                size: 64,
                color: theme.colorScheme.primary.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'No applications yet',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Check back later for new applicants.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicantCard(
      BuildContext context, ThemeData theme, application) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: theme.colorScheme.outline, width: 1),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ApplicantDetailScreen(application: application),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: AppSpacing.paddingLg,
          child: Row(
            children: [
              ProfileAvatar(
                imageUrl: null,
                name: application.applicantName,
                size: 56,
                avatarType: AvatarType.jobSeeker,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      application.applicantName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (application.applicantTitle != null) ...[
                      const SizedBox(height: 4.0),
                      Text(
                        application.applicantTitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4.0),
                    Text(
                      application.email,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
