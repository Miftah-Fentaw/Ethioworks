import 'package:flutter/material.dart';
import 'package:ethioworks/services/application_service.dart';
import 'package:ethioworks/providers/auth_provider.dart';
import 'package:ethioworks/providers/job_provider.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/models/application_model.dart';
import 'package:ethioworks/widgets/profile_avatar.dart';
import 'package:ethioworks/screens/mobile/employer/applicant_detail_page.dart';

import 'package:ethioworks/theme.dart';

class AllApplicantsScreen extends StatefulWidget {
  const AllApplicantsScreen({super.key});

  @override
  State<AllApplicantsScreen> createState() => _AllApplicantsScreenState();
}

class _AllApplicantsScreenState extends State<AllApplicantsScreen> {
  final ApplicationService _service = ApplicationService();
  List<Application> _applications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final jobProvider = context.read<JobProvider>();
    final auth = context.read<AuthProvider>();
    final employer = auth.currentEmployer;
    if (employer == null) {
      if (mounted)
        setState(() {
          _applications = [];
          _loading = false;
        });
      return;
    }

    final jobs =
        jobProvider.jobs.where((j) => j.employerId == employer.id).toList();
    final apps = <Application>[];
    for (final job in jobs) {
      final list = await _service.getApplicationsByJob(job.id);
      apps.addAll(list);
    }

    if (mounted)
      setState(() {
        _applications = apps;
        _loading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
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
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

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
            icon: Icon(Icons.filter_list_rounded,
                color: theme.colorScheme.onSurface),
            onPressed: () {},
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: _applications.isEmpty
          ? _buildEmptyState(theme)
          : ListView.builder(
              padding: AppSpacing.paddingLg,
              itemCount: _applications.length,
              itemBuilder: (context, i) {
                final a = _applications[i];
                return _buildApplicantCard(context, theme, a);
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
            child: Icon(Icons.people_outline_rounded,
                size: 64,
                color: theme.colorScheme.primary.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'No applicants yet',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Applications will appear here.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicantCard(
      BuildContext context, ThemeData theme, Application a) {
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
              builder: (_) => ApplicantDetailScreen(application: a),
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
                name: a.applicantName,
                size: 56,
                avatarType: AvatarType.jobSeeker,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.applicantName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      a.email,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
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
