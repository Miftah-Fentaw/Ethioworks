import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/models/job_post_model.dart';
import 'package:ethioworks/providers/auth_provider.dart';
import 'package:ethioworks/providers/job_provider.dart';
import 'package:ethioworks/screens/mobile/job_seeker/job_detail_page.dart';
import 'package:ethioworks/screens/mobile/job_seeker/job_seeker_profile_page.dart';
import 'package:ethioworks/widgets/job_card.dart';
import 'package:ethioworks/widgets/profile_avatar.dart';
import 'package:ethioworks/theme.dart';

class SeekerHomeScreen extends StatefulWidget {
  const SeekerHomeScreen({super.key});

  @override
  State<SeekerHomeScreen> createState() => _SeekerHomeScreenState();
}

class _SeekerHomeScreenState extends State<SeekerHomeScreen> {
  final Map<String, String?> _userReactions = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobProvider>().loadJobs();
    });
  }

  void _showFilterDialog() {
    final jobProvider = context.read<JobProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) => FilterBottomSheet(
        initialTitle: jobProvider.searchTitle,
        initialLocation: jobProvider.searchLocation,
        selectedLocationType: jobProvider.selectedLocationType,
        onApplyFilters: (title, location, locationType) {
          context.read<JobProvider>().filterJobs(locationType: locationType);
          context
              .read<JobProvider>()
              .searchJobs(title: title, location: location);
          Navigator.pop(context);
        },
        onClearFilters: () {
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
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EthioWorks',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary, // Primary color for logo text
                letterSpacing: -1,
              ),
            ),
            Text(
              'Find your dream job',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          _buildActionButton(
            theme,
            icon: Icons.tune_rounded,
            onTap: _showFilterDialog,
          ),
          const SizedBox(width: AppSpacing.sm),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SeekerProfileScreen()),
              );
            },
            child: ProfileAvatar(
              imageUrl: seeker?.profilePic,
              name: seeker?.name ?? 'User',
              size: 40,
              avatarType: AvatarType.jobSeeker,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
        ],
      ),
      body: Column(
        children: [
          // Search Bar below Header (Web style but for mobile)
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.surface,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _showFilterDialog,
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search,
                              color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              jobProvider.searchTitle.isNotEmpty
                                  ? jobProvider.searchTitle
                                  : 'Search jobs...',
                              style: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontWeight: jobProvider.searchTitle.isNotEmpty
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              color: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.surface,
              onRefresh: () => context.read<JobProvider>().loadJobs(),
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
                                final userId =
                                    authProvider.currentUser?.id ?? '';
                                await jobProvider.likeJob(job.id, userId);
                                final reaction = await jobProvider
                                    .getUserReaction(job.id, userId);
                                setState(
                                    () => _userReactions[job.id] = reaction);
                              },
                              onDislike: () async {
                                final userId =
                                    authProvider.currentUser?.id ?? '';
                                await jobProvider.dislikeJob(job.id, userId);
                                final reaction = await jobProvider
                                    .getUserReaction(job.id, userId);
                                setState(
                                    () => _userReactions[job.id] = reaction);
                              },
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(ThemeData theme,
      {required IconData icon, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: theme.colorScheme.onSurface, size: 20),
        onPressed: onTap,
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
                Icons.search_off_rounded,
                size: 64,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'No jobs found',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'We couldn\'t find any jobs matching your criteria. Try adjusting your filters or check back later.',
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

class FilterBottomSheet extends StatefulWidget {
  final String? initialTitle;
  final String? initialLocation;
  final LocationType? selectedLocationType;
  final Function(String, String, LocationType?) onApplyFilters;
  final VoidCallback onClearFilters;

  const FilterBottomSheet({
    super.key,
    this.initialTitle,
    this.initialLocation,
    required this.selectedLocationType,
    required this.onApplyFilters,
    required this.onClearFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late TextEditingController _titleController;
  late TextEditingController _locationController;
  LocationType? _tempLocationType;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _locationController = TextEditingController(text: widget.initialLocation);
    _tempLocationType = widget.selectedLocationType;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
        top: AppSpacing.md,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Search & Filter',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              TextButton(
                onPressed: widget.onClearFilters,
                child: Text(
                  'Reset All',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildTextField(
            theme,
            controller: _titleController,
            label: 'Job Title or Keywords',
            icon: Icons.work_outline_rounded,
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildTextField(
            theme,
            controller: _locationController,
            label: 'Location',
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildFilterSection(
            theme,
            title: 'Location Type',
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _buildFilterChip(theme, 'Remote', LocationType.remote),
                _buildFilterChip(theme, 'Permanent', LocationType.permanent),
                _buildFilterChip(theme, 'On-Site', LocationType.onSite),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          ElevatedButton(
            onPressed: () => widget.onApplyFilters(
              _titleController.text,
              _locationController.text,
              _tempLocationType,
            ),
            child: const Text('Show Results'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(ThemeData theme,
      {required TextEditingController controller,
      required String label,
      required IconData icon}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: theme.colorScheme.onSurfaceVariant),
        filled: true,
        fillColor:
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
      ),
    );
  }

  Widget _buildFilterSection(ThemeData theme,
      {required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        child,
      ],
    );
  }

  Widget _buildFilterChip(ThemeData theme, String label, LocationType value) {
    final isSelected = _tempLocationType == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _tempLocationType = isSelected ? null : value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
