import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/models/job_post_model.dart';
import 'package:ethioworks/providers/job_provider.dart';
import 'package:ethioworks/screens/web_and_desktop/job_seeker/job_detail_panel.dart';
import 'package:ethioworks/screens/web_and_desktop/job_seeker/apply_job_page.dart';
import 'package:ethioworks/widgets/job_card.dart';
import 'package:ethioworks/theme.dart';

class SeekerHomeScreen extends StatefulWidget {
  const SeekerHomeScreen({super.key});

  @override
  State<SeekerHomeScreen> createState() => _SeekerHomeScreenState();
}

class _SeekerHomeScreenState extends State<SeekerHomeScreen> {
  final Map<String, String?> _userReactions = {};
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobProvider>().loadJobs();
    });
  }

  JobPost? _selectedJob;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final jobProvider = context.watch<JobProvider>();

    final jobs = jobProvider.jobs;

    // Stable selection logic - only set if currently null and we have jobs
    if (_selectedJob == null && jobs.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _selectedJob == null) {
          setState(() => _selectedJob = jobs.first);
        }
      });
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header / Search Bar area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
            color: const Color(0xFF11213A),
            child: Column(
              children: [
                // Top Search Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 8,
                      child: _searchField('Software Engineer, Marketer...',
                          Icons.work_outline, _titleController),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          jobProvider.searchJobs(
                            title: _titleController.text,
                            location: _locationController.text,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF40E0D0),
                        foregroundColor: const Color(0xFF11213A),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Search',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ),
                    Spacer()
                   
            
                  ],
                ),
                const SizedBox(height: 24),
                // Stats/Count
                Text(
                  '${jobs.length} Jobs found for "${_titleController.text.isEmpty ? 'All Positions' : _titleController.text}" in "${_locationController.text.isEmpty ? 'All Locations' : _locationController.text}."',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 32),
                // Note: Filters removed as they don't match current data structure
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
              child: Row(
                children: [
                  // Column 1: Job List
                  Container(
                    width: 750,
                    margin: const EdgeInsets.only(right: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
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
                                              offset:
                                                  Offset(0, 20 * (1 - value)),
                                              child: Opacity(
                                                opacity: value,
                                                child: child,
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16),
                                            child: JobCard(
                                              job: job,
                                              userReaction:
                                                  _userReactions[job.id],
                                              onTap: () => setState(
                                                  () => _selectedJob = job),
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
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: theme.colorScheme.outline
                                .withValues(alpha: 0.1)),
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
                        child: JobDetailPanel(
                          key: ValueKey(_selectedJob?.id),
                          job: _selectedJob,
                          onApply: () {
                            if (_selectedJob != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ApplyJobScreen(job: _selectedJob!),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchField(
      String hint, IconData icon, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.white70, size: 20),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
