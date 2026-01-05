import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/providers/auth_provider.dart';
import 'package:ethioworks/providers/job_provider.dart';
import 'package:ethioworks/models/job_post_model.dart';
import 'package:ethioworks/screens/web_and_desktop/employer/employer_job_detail_page.dart';
import 'package:ethioworks/widgets/job_card.dart';
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

  JobPost? _selectedJob;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final jobProvider = context.watch<JobProvider>();

    final jobs = jobProvider.jobs;

    // Stable selection logic
    if (_selectedJob == null && jobs.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _selectedJob == null) {
          setState(() => _selectedJob = jobs.first);
        }
      });
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
        child: Row(
          children: [
            // Column 1: My Job Postings
            Container(
              width: 500,
              margin: const EdgeInsets.only(right: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Job Postings',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${jobs.length} Jobs',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: jobProvider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : jobs.isEmpty
                            ? _buildEmptyState(theme)
                            : ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: jobs.length,
                                itemBuilder: (context, index) {
                                  final job = jobs[index];
                                  return TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    duration: Duration(
                                        milliseconds: 300 + (index * 50)),
                                    curve: Curves.easeOut,
                                    builder: (context, value, child) {
                                      return Transform.translate(
                                        offset: Offset(0, 20 * (1 - value)),
                                        child: Opacity(
                                          opacity: value,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16),
                                      child: JobCard(
                                        job: job,
                                        onTap: () =>
                                            setState(() => _selectedJob = job),
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
            // Column 2: Detail View
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  // Force explicit colors to verify theme mode
                  color: theme.brightness == Brightness.dark
                      ? const Color(0xFF1A2A4A).withOpacity(0.5) // Dark Navy
                      : const Color(0xFFFFFFFF), // White
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: theme.brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.2)),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.05, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: _selectedJob == null
                      ? Center(
                          key: const ValueKey('no-selection'),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.business_center_outlined,
                                  size: 64,
                                  color: theme.colorScheme.primary
                                      .withValues(alpha: 0.3)),
                              const SizedBox(height: 16),
                              Text('Select a job posting to view details',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                      color:
                                          theme.colorScheme.onSurfaceVariant)),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          key: ValueKey(_selectedJob!.id),
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_selectedJob!.title,
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.attach_money,
                                      size: 20,
                                      color: theme.colorScheme.primary),
                                  const SizedBox(width: 4),
                                  Text(
                                    _selectedJob!.salary,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(width: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      _selectedJob!.locationType.name
                                          .toUpperCase(),
                                      style: TextStyle(
                                        color: theme
                                            .colorScheme.onPrimaryContainer,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              // Stats Row
                              Row(
                                children: [
                                  _statCard(theme, 'Likes',
                                      '${_selectedJob!.likes}', Icons.thumb_up),
                                  const SizedBox(width: 16),
                                  _statCard(
                                      theme,
                                      'Dislikes',
                                      '${_selectedJob!.dislikes}',
                                      Icons.thumb_down),
                                  const SizedBox(width: 16),
                                  _statCard(theme, 'Status', 'Active',
                                      Icons.check_circle,
                                      color: Colors.green),
                                ],
                              ),
                              const SizedBox(height: 32),
                              Text('Job Description',
                                  style: theme.textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              Text(_selectedJob!.description,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                      height: 1.6,
                                      color:
                                          theme.colorScheme.onSurfaceVariant)),
                              const SizedBox(height: 24),
                              Text('Required Skills',
                                  style: theme.textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _selectedJob!.expectedSkills
                                    .map((skill) => Chip(
                                          label: Text(skill),
                                          backgroundColor: theme
                                              .colorScheme.secondaryContainer,
                                          labelStyle: TextStyle(
                                            color: theme.colorScheme
                                                .onSecondaryContainer,
                                          ),
                                        ))
                                    .toList(),
                              ),
                              const SizedBox(height: 32),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EmployerJobDetailScreen(
                                            jobId: _selectedJob!.id),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(16),
                                    backgroundColor: theme.colorScheme.primary,
                                    foregroundColor:
                                        theme.colorScheme.onPrimary,
                                  ),
                                  icon: const Icon(Icons.people),
                                  label: const Text('View Applicants'),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(ThemeData theme, String label, String value, IconData icon,
      {Color? color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color ?? theme.colorScheme.primary, size: 20),
            const SizedBox(height: 8),
            Text(value,
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label,
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
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
            'Go to "Post Job" tab to create your first opening.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
