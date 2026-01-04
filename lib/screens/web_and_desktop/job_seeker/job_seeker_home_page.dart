import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/models/job_post_model.dart';
import 'package:ethioworks/providers/auth_provider.dart';
import 'package:ethioworks/providers/job_provider.dart';
import 'package:ethioworks/screens/web_and_desktop/job_seeker/job_detail_page.dart';
import 'package:ethioworks/screens/web_and_desktop/job_seeker/job_seeker_profile_page.dart';
import 'package:ethioworks/widgets/job_card.dart';
import 'package:ethioworks/widgets/profile_avatar.dart';
import 'package:ethioworks/theme.dart';

class SeekerHomeScreen extends StatefulWidget {
  const SeekerHomeScreen({super.key});

  @override
  State<SeekerHomeScreen> createState() => _SeekerHomeScreenState();
}

class _SeekerHomeScreenState extends State<SeekerHomeScreen> {
  LocationType? _selectedLocationType;
  final Map<String, String?> _userReactions = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobProvider>().loadJobs();
    });
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) => FilterBottomSheet(
        selectedLocationType: _selectedLocationType,
        onApplyFilters: (locationType) {
          setState(() => _selectedLocationType = locationType);
          context.read<JobProvider>().filterJobs(locationType: locationType);
          Navigator.pop(context);
        },
        onClearFilters: () {
          setState(() => _selectedLocationType = null);
          context.read<JobProvider>().clearFilters();
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _loadUserReactions(List<JobPost> jobs) async {
    final authProvider = context.read<AuthProvider>();
    final jobProvider = context.read<JobProvider>();
    final userId = authProvider.currentUser?.id ?? '';

    for (final job in jobs) {
      if (!_userReactions.containsKey(job.id)) {
        final reaction = await jobProvider.getUserReaction(job.id, userId);
        _userReactions[job.id] = reaction;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = context.watch<AuthProvider>();
    final jobProvider = context.watch<JobProvider>();
    final seeker = authProvider.currentJobSeeker;

    final jobs = jobProvider.jobs;
    _loadUserReactions(jobs);

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
            icon: Icon(Icons.filter_list_rounded,
                color: theme.colorScheme.onSurface),
            onPressed: _showFilterDialog,
            tooltip: 'Filter Jobs',
          ),
          const SizedBox(width: AppSpacing.sm),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SeekerProfileScreen()),
              );
            },
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ProfileAvatar(
                imageUrl: seeker?.profilePic,
                name: seeker?.name ?? 'User',
                size: 36,
                avatarType: AvatarType.jobSeeker,
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
            onRefresh: () => context.read<JobProvider>().loadJobs(),
            child: jobProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : jobs.isEmpty
                    ? _buildEmptyState(theme)
                    : ListView.builder(
                        padding: AppSpacing.paddingLg,
                        itemCount: jobs.length,
                        itemBuilder: (context, index) {
                          final job = jobs[index];
                          final userId = authProvider.currentUser?.id ?? '';

                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppSpacing.md),
                            child: JobCard(
                              job: job,
                              userReaction: _userReactions[job.id],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        JobDetailScreen(jobId: job.id),
                                  ),
                                );
                              },
                              onLike: () async {
                                await jobProvider.likeJob(job.id, userId);
                                final reaction = await jobProvider
                                    .getUserReaction(job.id, userId);
                                setState(
                                    () => _userReactions[job.id] = reaction);
                              },
                              onDislike: () async {
                                await jobProvider.dislikeJob(job.id, userId);
                                final reaction = await jobProvider
                                    .getUserReaction(job.id, userId);
                                setState(
                                    () => _userReactions[job.id] = reaction);
                              },
                            ),
                          );
                        },
                      ),
          ),
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
            child: Icon(Icons.work_off_rounded,
                size: 64,
                color: theme.colorScheme.primary.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'No jobs available',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Check back later for new opportunities.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  final LocationType? selectedLocationType;
  final Function(LocationType?) onApplyFilters;
  final VoidCallback onClearFilters;

  const FilterBottomSheet({
    super.key,
    required this.selectedLocationType,
    required this.onApplyFilters,
    required this.onClearFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  LocationType? _tempLocationType;

  @override
  void initState() {
    super.initState();
    _tempLocationType = widget.selectedLocationType;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Jobs',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Location Type',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  FilterChip(
                    label: const Text('Remote'),
                    selected: _tempLocationType == LocationType.remote,
                    onSelected: (selected) {
                      setState(() {
                        _tempLocationType =
                            selected ? LocationType.remote : null;
                      });
                    },
                  ),
                  FilterChip(
                    label: const Text('Permanent'),
                    selected: _tempLocationType == LocationType.permanent,
                    onSelected: (selected) {
                      setState(() {
                        _tempLocationType =
                            selected ? LocationType.permanent : null;
                      });
                    },
                  ),
                  FilterChip(
                    label: const Text('On-Site'),
                    selected: _tempLocationType == LocationType.onSite,
                    onSelected: (selected) {
                      setState(() {
                        _tempLocationType =
                            selected ? LocationType.onSite : null;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onClearFilters,
                      style: OutlinedButton.styleFrom(
                        padding: AppSpacing.paddingMd,
                      ),
                      child: const Text('Clear All'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => widget.onApplyFilters(_tempLocationType),
                      style: ElevatedButton.styleFrom(
                        padding: AppSpacing.paddingMd,
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
